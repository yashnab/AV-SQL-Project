/*create table for visitor logs */
CREATE TABLE visitorlogsdata
   ( webClientID VARCHAR(30)
   , VisitDateTime datetime
   , ProductID VARCHAR(30)
   , UserID VARCHAR(30)
   , Activity VARCHAR(30)
   ,Browser VARCHAR(30)
   ,OS VARCHAR(30)
   ,City VARCHAR(30)
   ,Country VARCHAR(30)
   
   ) ENGINE=Memory DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ;
   
   /*checking the data using select statement and limiting it to 2 entries*/
  select * from visitorlogsdata
  limit 2;
/*creating table for user registration */  
CREATE TABLE usersregitrationdata
   ( UserID VARCHAR(30)
   , SignupDate datetime
   ,UserSegment VARCHAR(10)
   ) ENGINE=Memory DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ;  
  
  /*checking data using select statement and limiting to 2 entries*/
   select * from usersregitrationdata
   limit 2;
   
   /*Data cleaning
   Upldating date  format in both the tables*/
   UPDATE visitorlogsdata SET VisitDateTime = DATE_FORMAT(VisitDateTime,'%Y/%m/%d')
   where VisitDateTime != "NaT";
   
   UPDATE usersregitrationdata SET SignupDate = DATE_FORMAT(SignupDate,'%Y/%m/%d')
   where SignupDate != "NaT";
   
   /*updating the product ids, activities and OS types to upper case bring uniformity*/
   UPDATE visitorlogsdata SET ProductID = upper(ProductID);
   
   UPDATE visitorlogsdata SET Activity = upper(Activity);
   
   UPDATE visitorlogsdata SET OS = upper(OS);
   
/*Most_Active_OS
In this we have to get which user is prefering which OS maximum times.
For getting the most active OS first we will create an inner query to 
get the user id, name as well as the count of all the OS for each user
from visitorlogsdata table.
Next added where clause to restrict the search for only last 7 days
and group by user id giving it an alias v.
Using left join to join inner query with outer query where we'll be 
extracting user id, most active os name and OS with maximum count
and lastly grouping it by user id to get distinct user id.
*/
select u.userID, Most_Active_OS, max(os_count) from usersregitrationdata u
left join (select v.UserID as userID,v.OS Most_Active_OS, count(v.OS) os_count from visitorlogsdata v
where v.VisitDateTime >= '2018/05/20' 
group by v.UserID
) v1 on u.UserID = v1.UserID
group by u.UserID order by u.UserID;

 

 
 /*No_of_days_Visited_7_Days
 In this we have to get how many times a user was active on platform in the last 7 days.
For getting the number of visited first we will create an inner query to 
get the user id and count of visitedatetime as No_of_days_Visited_7_Days for each user
from visitorlogsdata table.
Next added where clause to restrict the search for only last 7 days
and group by user id giving it an alias grp.
Using left join to join inner query with outer query where we'll be 
extracting user id and No_of_days_Visited_7_Days
and lastly grouping it by user id to get all distinct user ids.
*/
 
select u.userID, grp.No_of_days_Visited_7_Days from usersregitrationdata u
left join (select v.UserID as userID, count(v.VisitDateTime) No_of_days_Visited_7_Days from visitorlogsdata v
where v.VisitDateTime >= '2018/05/20' 
group by v.UserID
) as grp on grp.userID = u.userID
order by u.UserID;


   
 /*No_Of_Products_Viewed_15_Days
In this we have to get number of products viewed by the user in the last 15 days.
For getting the number of visited first we will create an inner query to 
get the user id as user id and count of product ids as no_of_products_viewed for each user
from visitorlogsdata table.
Next added where clause to restrict the search for only last 15 days
and group by user id giving it an alias grp.
Using left join to join inner query with outer query where we'll be 
extracting user id and no_of_products_viewed
and lastly grouping it by user id to get all distinct user ids.
 */
 
select u.userID, grp.No_Of_Products_Viewed_15_Days from usersregitrationdata u
left join (select v.UserID as userID, count(v.productID) No_Of_Products_Viewed_15_Days from visitorlogsdata v
where v.VisitDateTime >= '2018/05/12' 
group by v.UserID
) as grp on grp.userID = u.userID
order by u.UserID;


/*Most_Viewed_product_15_Days
In this we have to get most frequently viewed product by the user in the last 15 days.
For getting the most frequently viewed product first we will create an inner query to 
get the user id, product id as product viewed and count of product ids as pd_count for each user
from visitorlogsdata table.
Next added where clause to restrict the search for only last 15 days and where the activity was pageload
then grouping by user id giving it an alias v1.
Using left join to join inner query with outer query where we'll be 
extracting user id, product id and max pd_count
We will also be giving case when clause for if the user has not viewed any product in the last 15 days 
Then put Product101 otherwise put product id
and lastly grouping it by user id to get all distinct user ids.
*/

select u.UserID as UserID, case when product_viewed is null then "Product101" else product_viewed end as Most_Viewed_product_15_Days, max(pd_count) from usersregitrationdata u
left join (select v.UserId, v.ProductId product_viewed, count(v.ProductId) as pd_count from  visitorlogsdata v 
where v.VisitDateTime >= '2018/05/12' and Activity = "PAGELOAD"
group by v.UserId) v1 on u.UserID = v1.UserID
group by u.UserID order by u.UserID;




/*Pageloads_last_7_days
In this we have to get most frequently viewed product by the user in the last 15 days.
For getting the most frequently viewed product first we will create an inner query to 
get the user id, product id as product viewed and count of product ids as pd_count for each user
from visitorlogsdata table.
Next added where clause to restrict the search for only last 15 days and where the activity was pageload
then grouping by user id giving it an alias v1.
Using left join to join inner query with outer query where we'll be 
extracting user id, product id and max pd_count
We will also be giving case when clause for if the user has not viewed any product in the last 15 days 
Then put Product101 otherwise put product id
and lastly grouping it by user id to get all distinct user ids.
*/
select u.userID, grp.Pageloads_last_7_days from usersregitrationdata u
left join (select v.UserID as userID, count(v.Activity) Pageloads_last_7_days from visitorlogsdata v
where v.VisitDateTime >= '2018/05/20' and Activity = "PAGELOAD"
group by v.UserID
) as grp on grp.userID = u.userID
order by u.UserID;

##Clicks_last_7_days
select u.userID, grp.Click_last_7_days from usersregitrationdata u
left join (select v.UserID as userID, count(v.Activity) Click_last_7_days from visitorlogsdata v
where v.VisitDateTime >= '2018/05/20' and Activity = "CLICK"
group by v.UserID
) as grp on grp.userID = u.userID
order by u.UserID;



##Recently_Viewed_Product
select u.userID, case when grp.ProductId is null then "Product101" else grp.ProductId end as Recently_Viewed_Product from usersregitrationdata u
left join (select UserId, ProductId , max(VisitDateTime) as visit_time from visitorlogsdata
group by UserID order by UserId) as grp on grp.userID = u.userID
order by u.UserID;

/*UserID*/
select distinct UserId from usersregitrationdata
order by UserId;


##vintage_user
select UserId, round(datediff('2018/05/28', SignupDate)/365,1) vintage_year from usersregitrationdata
order by UserId;
