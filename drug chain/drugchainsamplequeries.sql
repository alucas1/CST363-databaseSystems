-- List the name of the patient, pharmacy id, and prescription filled
-- date for all patients who have filled their prescriptions at any CVS or Walgreens
SELECT p.patientfirstname,
       p.patientlastname,
       ph.pharmid,
       rx.prescdatefilled
FROM   patient p
       INNER JOIN prescription rx
               ON p.patientid = rx.patientid
       INNER JOIN pharmacy ph
               ON rx.pharmacyfilled = ph.pharmid
WHERE  ph.pharmname IN ( 'CVS', 'Walgreens' );  


-- List the doctors, the doctor ids, their years of experience, and the number
-- of prescriptions they have given out in the year 2020
SELECT rx.docid,
       d.docfirstname,
       d.doclastname,
       d.docyearsexperience,
       Count(*) AS rxGiven
FROM   prescription rx
       INNER JOIN doctor d
               ON rx.docid = d.docid
WHERE  rx.prescdate LIKE '2020%'
GROUP  BY rx.docid;  


-- Display the average price of all the drugs sold by a specific pharmaceutical company
-- given that the average price is greater than the average of all the drugs. 
WITH avgprice(pharmacompname, avgdrugprice)
     AS (SELECT phc.pcname,
                Avg(s.price)
         FROM   sells s
                INNER JOIN drug d
                        ON s.drugname = d.drugname
                INNER JOIN pharmacompany phc
                        ON phc.pcname = d.pcname
         GROUP  BY phc.pcname)
SELECT pharmacompname,
       avgdrugprice
FROM   avgprice
WHERE  avgdrugprice > (SELECT Avg(price) FROM sells);  


-- Display the total count of contracts that a pharmacy has with a specific pharmaceutical company. 
SELECT ph.pharmname,
       phc.pcname,
       Count(*) AS contractcount
FROM   contract c
       INNER JOIN pharmacompany phc
               ON phc.pcname = c.pcname
       INNER JOIN pharmacy ph
               ON ph.pharmid = c.pharmid
GROUP  BY ph.pharmname,
          phc.pcname;  

-- Display a list of patient names who were prescribed drugs by 
-- blackmart and who's prescription was filled by walgreens. Include
-- the drugname and formula name they were prescribed.
SELECT p.patientfirstname,
       p.patientlastname,
       rx.drugname,
       d.drugformula
FROM   patient p
       INNER JOIN prescription rx
               ON p.patientid = rx.patientid
       INNER JOIN drug d
               ON rx.drugname = d.drugname
       INNER JOIN pharmacy ph
               ON rx.pharmacyfilled = ph.pharmid
WHERE  d.pcname = 'Blackmart'
       AND ph.pharmname = 'Walgreens';  
