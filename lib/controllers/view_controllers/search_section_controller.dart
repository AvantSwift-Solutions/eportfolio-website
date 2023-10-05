import 'dart:async';
import 'package:avantswift_portfolio/dto/search_results_dto.dart';
import 'package:avantswift_portfolio/dto/section_results_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_words/english_words.dart' as english_words;

class SearchSectionController {
  Future<List<SectionResultDTO>> searchDatabase(String query) async {

    // Use searchAllCollections to get search results
    final searchResults = await searchAllCollections(query);
    List<SectionResultDTO> resultsWithSection = [
      SectionResultDTO(sectionName: 'No Results', section: Sections.Experience)
    ];
    // Filter the documentData based on the query and word  =validation
    searchResults
        .where((result) {
          final documentDataJson = result.documentData.toString();

          // Check if the JSON representation contains the query
          // Capture 30 characters surrounding the queried term
          final startIndex =
              documentDataJson.toLowerCase().indexOf(query.toLowerCase());
          final endIndex =
              documentDataJson.toLowerCase().indexOf(query.toLowerCase()) +
                  query.length +
                  20;

          final snippet = documentDataJson.substring(
            startIndex < 0 ? 0 : startIndex,
            endIndex > documentDataJson.length
                ? documentDataJson.length
                : endIndex,
          );

          result.documentData['snippet'] = snippet;

          // Split the snippet into words
          String formattedSnippet =
              snippet.replaceAll(',', ' ').replaceAll('}', ' ');

          List<String> relevantWords = formattedSnippet.split(' ');
          List<String> wordsToDisplay = [relevantWords.removeAt(0)];

          for (var word in relevantWords) {
            if (english_words.all.contains(word)) {
              wordsToDisplay.add(word);
            } else {
              break;
            }
          }
          final stringToDisplay = wordsToDisplay.join(' ');

          resultsWithSection.add(SectionResultDTO(
            section: SectionResultDTO.toSectionsEnumFromString(
                result.collectionName),
            sectionName:
                '${SectionResultDTO.stringFromEnum(SectionResultDTO.toSectionsEnumFromString(result.collectionName))}$stringToDisplay',
          ));
          result.documentData['searchResult'] = stringToDisplay;

          return true;
        })
        .map((result) =>
            result.documentData['searchResult'] ??
            'No Results') // Extract the snippet
        .toList();

    if (resultsWithSection.length > 1) {
      // Remove no results found
      resultsWithSection.removeAt(0);
    }

    // print('$query: $finalResults\n\n\n\n\n');
    return resultsWithSection;
    // return filteredResults.take(5).toList(); // Return the first 5 filtered results
  }
}

Future<List<SearchResult>> searchAllCollections(String keyword) async {
  final firestore = FirebaseFirestore.instance;
  final List<SearchResult> searchResults = [];

  // Replace 'collectionNames' with a list of your collection names
  final List<String> collectionNames = [
    'ISkill',
    'AwardCert',
    'Education',
    'Experience',
    'Project',
    'Recommendation',
    'TSkill',
    'User'
  ];

  for (final collectionName in collectionNames) {
    final QuerySnapshot<Map<String, dynamic>> result =
        await firestore.collection(collectionName).get();

    // Process the documents in this collection
    for (var document in result.docs) {
      final data = document.data();

      // Check every field in the document for the keyword
      data.forEach((key, value) {
        if (value is String &&
            value.toString().toLowerCase().contains(keyword.toLowerCase())) {
          searchResults.add(
              SearchResult(collectionName: collectionName, documentData: data));
          return; // Stop checking other fields in this document
        }
      });
    }
  }

  return searchResults;
}
