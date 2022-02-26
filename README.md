# Auction
This was just an auction product and sales application. Users can post products with the product title, description, End bid date, minimum bid price. Another user can see a list of auctionable products and can bid after End bid time show winner based on the maximum value.

## All User Interface
### Login
![WhatsApp Image 2022-02-26 at 11 04 03 PM (4)](https://user-images.githubusercontent.com/75753499/155852197-ee0e44fb-e5df-4042-b6de-582df2c7d0b1.jpeg)
### Registration
![WhatsApp Image 2022-02-26 at 11 04 03 PM (3)](https://user-images.githubusercontent.com/75753499/155852240-023c3e24-0f00-40fd-9e70-f17a1fbf5056.jpeg)
### Home
![home](https://user-images.githubusercontent.com/75753499/155852327-69d6c353-a82a-4a86-9c19-98a469b90827.jpeg)
### Dashboard
![WhatsApp Image 2022-02-26 at 11 04 03 PM (2)](https://user-images.githubusercontent.com/75753499/155852353-bae8f105-85d5-4bac-98cf-7a34ab758cb4.jpeg)
### Product Details
![ddd](https://user-images.githubusercontent.com/75753499/155852380-aa70e328-34ea-433a-b0f3-7d48cd9bd60c.jpeg)
### End Bid 
![WhatsApp Image 2022-02-26 at 11 04 03 PM](https://user-images.githubusercontent.com/75753499/155852421-7f7570f1-f6ec-414e-ae18-6ac110585fab.jpeg)
### Add Bid
![a](https://user-images.githubusercontent.com/75753499/155852438-6853a32e-1586-48f3-83c3-608d2d514862.jpeg)
### Profile 
![WhatsApp Image 2022-02-26 at 11 04 03 PM (1)](https://user-images.githubusercontent.com/75753499/155852465-fb018ea9-9d4a-48a5-81dc-1f3a5db57dc8.jpeg)

## Packages use
### Firebase Auth
This package is used to check user authentication. Like Email validation, Email verified check. Send Email verification link and some others
### File picker
This package is used to pick image and handle file problem.
### Cloud Firestore
This application need to store some user information here i use firebase database and this package help to store data in firebase cloud store and reuse data.
### Syncfusion flutter charts
This was a very usefull package . This package are have many graph Like Line chart, pichart,barchart and some othes
This apps are require show some statistic result that whay use this packege.
### Random string
Random string packege are help to generate unique string and i use here as a document id.

## Face problem & solve
This project i face two problem. Handle bid end data and handle maximum bid price. My solution is when user one user add bid store this price than another user bid this time i was retrive previus price and convert as a integer then add new price and old price. than store new maximum value in firbease.
2nd is end date handle that time at first take current date time then compare current date time and end date time. if result is 0 that means this auction is end this was very funny for me.
### [Auction Apps Link](https://drive.google.com/file/d/1m9hpepsCcslf85v5EuIJopLouXS_oXzT/view?usp=sharing).


