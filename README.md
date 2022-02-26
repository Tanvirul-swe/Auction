# Auction
This was just an auction product and sales application. Users can post products with the product title, description, End bid date, minimum bid price. Another user can see a list of auctionable products and can bid after End bid time show winner based on the maximum value.

## All User Interface

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

