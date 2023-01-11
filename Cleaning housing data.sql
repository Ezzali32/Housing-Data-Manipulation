select*
from dbo.housing

-- sale date format edited

select saledateedited, Convert(Date,Saledate)
from dbo.housing

alter table  housing
add saledateedited date;

update housing
set saledateedited= convert(date,saledate)

--property address

select *
from dbo.housing
--where propertyaddress is null
order by parcelid

select z.parcelid,z.propertyaddress,x.parcelid,x.propertyaddress, isnull(z.propertyaddress,x.propertyaddress)
from dbo.housing z
join dbo.housing x
on z.parcelid=x.parcelid
and z.[UniqueID ] <>x.[UniqueID]
where z.propertyaddress  is null

Update z
Set propertyaddress= isnull(z.propertyaddress,x.propertyaddress)
from dbo.housing z
join dbo.housing x
on z.parcelid=x.parcelid
and z.[UniqueID ] <>x.[UniqueID]
where z.propertyaddress  is null

--address breakdown
select propertyaddress
from dbo.housing
--where propertyaddress is null

select 
substring(propertyaddress,1,charindex(',',propertyaddress)-1) as address
,substring(propertyaddress,charindex(',',propertyaddress)+1, len(propertyaddress)) as address
from dbo.housing 

alter table  housing
add propertysplitaddresss Nvarchar(255);

update housing
set propertysplitaddresss = substring(propertyaddress,1,charindex(',',propertyaddress)-1)


alter table  housing
add propertyssplitcity Nvarchar(255);

update housing
set propertyssplitcity= substring(propertyaddress,charindex(',',propertyaddress)+1, len (propertyaddress))

 
select owneraddress
from dbo.housing

select
PARSENAME(replace(Owneraddress,',','.'),3),
PARSENAME(replace(Owneraddress,',','.'),2),
PARSENAME(replace(Owneraddress,',','.'),1)
from dbo.housing

alter table  housing
add ownersplitaddresss Nvarchar(255);

update housing
set ownersplitaddresss = PARSENAME(replace(Owneraddress,',','.'),3)


alter table  housing
add ownersplitcity Nvarchar(255);

update housing
set ownersplitcity= PARSENAME(replace(Owneraddress,',','.'),2)

alter table  housing
add ownersplitstate Nvarchar(255);

update housing
set ownersplitstate= PARSENAME(replace(Owneraddress,',','.'),1)

select *
from dbo.housing

--sold as vaacant column

select distinct(soldasvacant), count(soldasvacant)
from housing 
group by soldasvacant
order by 2

select soldasvacant
, case when soldasvacant= 'Y' THEN 'YES'
WHEN SOLDASVACANT='N' THEN 'NO'
ELSE SOLDASVACANT
end
from dbo.housing 

update dbo.housing
set soldasvacant= case when soldasvacant= 'Y' THEN 'YES'
WHEN SOLDASVACANT='N' THEN 'NO'
ELSE SOLDASVACANT
end

--duplicates

with rownumcte as(
select*,
Row_Number () over(
partition by parcelid,
             propertyaddress,
             saleprice,
             saledate,
             legalreference

			 order by
			 uniqueid
			 )row_num
from dbo.housing

)
delete
from rownumcte
where row_num>1

--remove columns

select*
from dbo.housing

alter table dbo.housing
drop column owneraddress,taxdistrict,propertyaddress
alter table dbo.housing
drop column saledate