create database Project_2

use Project_2

select * from shrktnk

--Total number of episodes--

select max(EpNo) from shrktnk
OR
select count(distinct EpNo) from shrktnk

--Pitches--
select count(distinct Brand) from shrktnk

--Pitch Funded--
select count(Amtinvested) from shrktnk where not Amtinvested='0';
OR;
select count(rec_inv)as funding_rec  from
(select amtinvested, case when amtinvested>0 then 'Yes' else 'No' end as Rec_inv from shrktnk)a 
where Rec_inv='Yes';
Or;                  --Percentage Form--
select cast(sum(a.Rec_inv)as float)/cast(count(*) as float)*100 from
(select amtinvested, case when amtinvested>0 then 1 else 0 end as Rec_inv from shrktnk)a 

--Total Male and Female--
select sum(male) as Total_Males from shrktnk
select sum(Female) as Total_females from shrktnk

--Gender Ratio--
Select sum(female)/sum(male) as Gender_Ratio from shrktnk

-- Total Amount Invested --
Select Sum(amtinvested) as total_amt_invested from shrktnk 

--Average Equity Taken--
select sum(Eq_taken)/count(Eq_taken) from shrktnk where eq_taken>0
OR;
select avg(a.Eq_taken) from
(select Eq_taken from shrktnk where Eq_taken>0)a

--Highest amount and equity In the Show--

select max(amtinvested)from shrktnk 
select max(Eq_taken)from shrktnk 

--No. of teams where there is atleast 1 female--

select sum(a.Teams) as No_of_teams from
(select female,case when female>0 then 1 else 0 end as Teams from shrktnk)a

--pitches converted having atleast one women--

select count(brand) from shrktnk where female>0 and Amtinvested>0
OR;
select sum(b.female_teams) from 
(select case when female>0 then 1 else 0 end as female_teams from 
(select * from shrktnk where not deal='No Deal')a)b

--Average Number of team members in every team--

select sum(Team_mem)/count(Team_mem) from shrktnk

--Average Amt Invested per Deal--

select sum(a.Amtinvested)/count(a.Amtinvested) from 
(select * from shrktnk where Amtinvested>0)a

--Average Age of Members,Location,sector of Teams--

select top 1 avgage,count(avgage) as cnt from shrktnk group by [Avgage] order by cnt desc
select top 1 Location,count(Location) as cnt from shrktnk group by Location order by cnt desc
select top 1 Sector,count(Sector) as cnt from shrktnk group by sector order by cnt desc

--No. of Partner Deals--

select partners, count(partners) cnt from shrktnk where Partners!='-' group by Partners order by cnt desc

--Making the Matrix--

select * from shrktnk
---step 1---
-Ashneer-
select 'Ashneer'as name,count(ashneeramtinv)total_deals_present from shrktnk where ashneeramtinV>=0;
select 'Ashneer'as name,count(ashneeramtinv)total_deals_made from shrktnk where ashneeramtinV!=0;
select 'Ashneer'as name,sum(c.ashneeramtinv)total_inv,avg(c.ashneereqt)avg_eq from 
(select * from shrktnk where ashneeramtinv!=0)c

select 'aman'as name,count(amanamtinv)total_deals_present from shrktnk where amanamtinv>=0;
select 'aman'as name,count(amanamtinv)total_deals_made from shrktnk where amanamtinv!=0;
select 'aman'as name,sum(c.amanamtinv)total_inv,avg(c.amaneqt)avg_eq from 
(select * from shrktnk where amanamtinv!=0)c

select 'namita'as name,count(namitaamtinv)total_deals_present from shrktnk where namitaamtinv>=0;
select 'namita'as name,count(namitaamtinv)total_deals_made from shrktnk where namitaamtinv!=0;
select 'namita'as name,sum(c.namitaamtinv)total_inv,avg(c.namitaeqt)avg_eq from 
(select * from shrktnk where namitaamtinv!=0)c

select 'anupam'as name,count(anupamamtinv)total_deals_present from shrktnk where anupamamtinv>=0;
select 'anupam'as name,count(anupamamtinv)total_deals_made from shrktnk where anupamamtinv!=0;
select 'anupam'as name,sum(c.anupamamtinv)total_inv,avg(c.anupameqt)avg_eq from 
(select * from shrktnk where anupamamtinv!=0)c

select 'vineeta'as name,count(vineetaamtinv)total_deals_present from shrktnk where vineetaamtinv>=0;
select 'vineeta'as name,count(vineetaamtinv)total_deals_made from shrktnk where vineetaamtinv!=0;
select 'vineeta'as name,sum(c.vineetaamtinv)total_inv,avg(c.vineetaeqt)avg_eq from 
(select * from shrktnk where vineetaamtinv!=0)c

select 'peyush'as name,count(cast(peyushamtinv as int))total_deals_present from shrktnk where peyushamtinv>=0;
select 'peyush'as name,count(peyushamtinv)total_deals_made from shrktnk where peyushamtinv!=0;
select 'peyush'as name,sum(cast(d.peyushamtinv as int)) total_inv,avg(cast(d.peyusheqt as int))avg_eq from 
(select * from shrktnk where peyushamtinv!=0)d

select 'ghazal'as name,count(ghazalamtinv)total_deals_present from shrktnk where ghazalamtinv>=0;
select 'ghazal'as name,count(ghazalamtinv)total_deals_made from shrktnk where ghazalamtinv!=0;
select 'ghazal'as name,sum(c.ghazalamtinv)total_inv,avg(c.ghazaleqt)avg_eq from 
(select * from shrktnk where ghazalamtinv!=0)c
---step2---

select m.name,m.Total_deals_present,m.deals_made,n.total_inv,n.avg_eq  from
(select a.name,a.Total_deals_present,b.deals_made  from
(select 'ashneer' as name,count(ashneeramtinv)as Total_deals_present from shrktnk)a
inner join
(select 'ashneer' as name,count(ashneeramtinv)as deals_made from shrktnk where Ashneeramtinv>0)b
on a.name=b.name)m
inner join
(select 'Ashneer' as name,sum(c.ashneeramtinv)total_inv,avg(c.ashneereqt)avg_eq from
(select * from shrktnk where Ashneeramtinv!=0)c)n
on m.name=n.name

union 

select m.name,m.total_deals_present,m.total_deals_made,n.total_inv,n.avg_eq from
(select a.name,a.total_deals_present,b.total_deals_made from
(select 'aman'as name,count(amanamtinv)total_deals_present from shrktnk where amanamtinv>=0)a
inner join 
(select 'aman'as name,count(amanamtinv)total_deals_made from shrktnk where amanamtinv!=0)b
on a.name=b.name)m
inner join
(select 'aman'as name,sum(c.amanamtinv)total_inv,avg(c.amaneqt)avg_eq from 
(select * from shrktnk where amanamtinv!=0)c)n
on m.name=n.name

union

select m.name,m.total_deals_present,m.total_deals_made,n.total_inv,n.avg_eq from
(select a.name,a.total_deals_present,b.total_deals_made from
(select 'namita'as name,count(namitaamtinv)total_deals_present from shrktnk where namitaamtinv>=0)a
inner join 
(select 'namita'as name,count(namitaamtinv)total_deals_made from shrktnk where namitaamtinv!=0)b
on a.name=b.name)m
inner join
(select 'namita'as name,sum(c.namitaamtinv)total_inv,avg(c.namitaeqt)avg_eq from 
(select * from shrktnk where namitaamtinv!=0)c)n
on m.name=n.name

union

select m.name,m.total_deals_present,m.total_deals_made,n.total_inv,n.avg_eq from
(select a.name,a.total_deals_present,b.total_deals_made from
(select 'anupam'as name,count(anupamamtinv)total_deals_present from shrktnk where anupamamtinv>=0)a
inner join 
(select 'anupam'as name,count(anupamamtinv)total_deals_made from shrktnk where anupamamtinv!=0)b
on a.name=b.name)m
inner join
(select 'anupam'as name,sum(c.anupamamtinv)total_inv,avg(c.anupameqt)avg_eq from 
(select * from shrktnk where anupamamtinv!=0)c)n
on m.name=n.name

union 

select m.name,m.total_deals_present,m.total_deals_made,n.total_inv,n.avg_eq from
(select a.name,a.total_deals_present,b.total_deals_made from
(select 'vineeta'as name,count(vineetaamtinv)total_deals_present from shrktnk where vineetaamtinv>=0)a
inner join 
(select 'vineeta'as name,count(vineetaamtinv)total_deals_made from shrktnk where vineetaamtinv!=0)b
on a.name=b.name)m
inner join
(select 'vineeta'as name,sum(c.vineetaamtinv)total_inv,avg(c.vineetaeqt)avg_eq from 
(select * from shrktnk where vineetaamtinv!=0)c)n
on m.name=n.name

union

select m.name,m.total_deals_present,m.total_deals_made,n.total_inv,n.avg_eq from
(select a.name,a.total_deals_present,b.total_deals_made from
(select 'peyush'as name,count(peyushamtinv)total_deals_present from shrktnk where peyushamtinv>=0)a
inner join 
(select 'peyush'as name,count(peyushamtinv)total_deals_made from shrktnk where peyushamtinv!=0)b
on a.name=b.name)m
inner join
(select 'peyush'as name,sum(c.peyushamtinv)total_inv,avg(c.peyusheqt)avg_eq from 
(select * from shrktnk where peyushamtinv!=0)c)n
on m.name=n.name

union

select m.name,m.total_deals_present,m.total_deals_made,n.total_inv,n.avg_eq from
(select a.name,a.total_deals_present,b.total_deals_made from
(select 'ghazal'as name,count(ghazalamtinv)total_deals_present from shrktnk where ghazalamtinv>=0)a
inner join 
(select 'ghazal'as name,count(ghazalamtinv)total_deals_made from shrktnk where ghazalamtinv!=0)b
on a.name=b.name)m
inner join
(select 'ghazal'as name,sum(c.ghazalamtinv)total_inv,avg(c.ghazaleqt)avg_eq from 
(select * from shrktnk where ghazalamtinv!=0)c)n
on m.name=n.name

--Maximum amoumt of funding received in each sector--

select * from 
(select brand,sector,amtinvested,rank() over(partition by sector order by amtinvested desc) rnk from shrktnk)a
where rnk=1 and amtinvested is not null
OR;
select * from 
(select a.brand,a.sector,a.amtinvested,a.eq_taken, rank() over (partition by a.sector order by amtinvested desc)rnk from
(select brand,sector,amtinvested,eq_taken from shrktnk where amtinvested is not null)a)b
where rnk=1




