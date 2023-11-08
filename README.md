# AvantSwift Solutions ePortfolio

This ePortfolio is the subject work for *IT Project COMP30022_2023_SM2*. The product is a website that includes a publicly viewable portfolio and an admin page that allows the client to edit the information in the portfolio. The product also includes a phone application that provides the functionality of the admin page which can be found [here](<https://github.com/AvantSwift-Solutions/eportfolio-phone-app>).

## Table of Contents

1. [Team Overview](#1-team-overview)
2. [Product Deployment](#2-product-deployment)\
    2.1. [Release History](#21-release-history) \
    2.2. [Showcase](#22-showcase)
3. [Installation Guide](#3-installation-guide)
4. [Architecture Overview](#4-architecture-overview) \
    4.1. [System Diagram](#41-system-diagram) \
    4.2. [API References](#42-api-references) \
    4.3. [Deployment Pipeline](#43-deployment-pipeline) \
    4.3. [Database Schema](#44-database-schema) \
    4.5. [Component Relationships](#45-component-relationships)
5. [Documentation Overview](#5-documentation-overview)
6. [FAQ](#6-faq)

## 1. Team Overview

**Team Contact email**: <avantswiftsolutions@gmail.com>

Amritesh Dasgupta, <adasgupta@student.unimelb.edu.au>, 1226974 \
Mohamad Danielsyah Mahmud, <mohamaddanie@student.unimelb.edu.au>, 1190847 \
Ashley Zhang, <aszhang@student.unimelb.edu.au>, 1170203 \
Khai Syuen Tan, <khaisyuent@student.unimelb.edu.au>, 1190030 \
Vincent Luu, <luuvl@student.unimelb.edu.au>, 1269979

## 2. Product Deployment

### 2.1 Release History

*Please refer to: [Release History](<https://avantswiftsolutions.atlassian.net/wiki/spaces/SD/pages/13795340/Release+History>)*

### 2.2 Showcase

*For a showcase, please refer to: [Product Page](<https://avantswiftsolutions.atlassian.net/wiki/spaces/SD/pages/7733320/Product+Page>)*

**Public ePortfolio**: <https://stevenzhou.web.app>\
**Admin Page**: <https://stevenzhou.web.app/#/login>

## 3. Installation Guide

These steps allow you to run the website locally on your machine.

1. Clone the repository to your local machine:

```bash
git clone https://github.com/AvantSwift-Solutions/AvantSwift-Solutions.git
```

2. Follow the steps to install and setup Flutter: <https://docs.flutter.dev/get-started/install>

3. Install the dependencies:

```bash
flutter pub get
```

4. Run the application locally (choose `2` to run on Chrome):

```bash
flutter run
```

## 4. Architecture Overview

*For more information on architecture, please refer to `docs/4+1 Architecture View Model.pdf`*

### 4.1. System Diagram

![System Diagram](https://github.com/AvantSwift-Solutions/eportfolio-website/assets/118659767/f8c04efe-3abd-431c-89e4-dc32d0be6c28)

### 4.2. API References

- Firebase Firestore Database: <https://firebase.google.com/docs/firestore>
- Firebase Storage: <https://firebase.google.com/docs/storage>
- Firebase Authentication: <https://firebase.google.com/docs/auth>
- Firebase Hosting: <https://firebase.google.com/docs/hosting>
- EmailJS (REST API): <https://www.emailjs.com/docs/rest-api/send/>

Note: Firestore is the database while Firebase Storage is used to store files such as images and assets.

### 4.3. Deployment Pipeline

A key takeaway is that the main branch will be automatically deployed to the production website. As such, beware of pushing to the main branch.

![Deployment Pipeline](https://github.com/AvantSwift-Solutions/eportfolio-website/assets/118659767/96e47723-8d8e-491b-b00c-83eee15e7b2c)


### 4.4. Database Schema

![Database Schema](https://github.com/AvantSwift-Solutions/eportfolio-website/assets/118659767/e97369e8-3477-4330-9174-7d290e2daf9b)


### 4.5. Component Relationships

![Component Relationships](https://github.com/AvantSwift-Solutions/eportfolio-website/assets/118659767/db887e2d-851f-4446-ab82-e9eb7bde764c)

**Pages**: These pages are accessible by administrators for making changes and edits to the application. Broken into 2 folders, one for admin and one for view

**Widgets**: Widgets are modular components that can be reused across different pages. They help in breaking down complex pages into smaller parts.

**Controllers**: Controllers manage the functionality of the application. We have separate controllers for both admin and view pages to handle their respective logic.

**Models**: Models represent the structure of data within the application. They are used to maintain consistency and structure while handling data.

**Services**: Services encapsulate specific functionalities, such as authentication, that can be reused throughout the application.

**UI**: Custom UI components, such as buttons or specialized UI elements, are stored here for consistency and reusability.

**Assets**: All images and static assets are stored in this folder for easy management.

## 5. Documentation Overview

The following documents can be found in the `docs` folder:

- 4+1 Architecture View Model
- Code Coverage Report
- Requirements Document
- User Stories

If you would like to see all of the product's documentation and artefact, please refer to our [Confluence](<https://avantswiftsolutions.atlassian.net/wiki/spaces/SD/overview>).

## 6. FAQ

Q: How do I access the admin page? \
A: Please navigate to <https://stevenzhou.web.app/#/login>.
Note: The team decided to not include a login button on the public ePortfolio to prevent viewers from trying to login.

Q: How do I change my login email? \
A: Please contact the team at <avantswiftsolutions@gmail.com>.

Q: How do I change my password? \
A: Please use the "Forgot My Password" feature on the login page.

Q: How do I make changes  to my ePortfolio? \
A: Please refer to the [User Guide](<https://avantswiftsolutions.atlassian.net/wiki/spaces/SD/pages/13795368/Admin+View+Showcase>).

Q: How do I undo an edit/deletion to my ePortfolio? \
A: Unfortunately, there is currently no way to undo a change.

Q: Are the analytic statistics legitmate? \
A: Yes, they are completely legitimate. The team has carefully tested them and do not tamper with the statistics in any way.

Q: Can you build me a website or an app? \
A: Possibly. Please contact the team at <avantswiftsolutions@gmail.com>.

---

[Back to Top](#avantswift-solutions-eportfolio)
