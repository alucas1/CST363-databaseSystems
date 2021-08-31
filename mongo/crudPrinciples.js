//Name:Alberto Lucas
//Date:02/16/2021
//Class:CST363
//Desc: familiarize youself with mongodb shell commands to insert, retrieve, update and delete documents.

// Parts 1.1 and 1.2
print("********************************");
print("Creating collection \"patients\" and insterting documents...");
db.patients.insertMany( [
{
	"ssn":"123456789",
	"name":{ 
           "last_name": "Alberto",
           "first_name": "Francesco"
          },
	"age": 10,
	"address":{ 
           "street": "Attn:  Supt. Window Services; PO Box 7005",
           "city": "WI",
           "state": "Madison",
           "zip": "53707"
           }
},
{
	"ssn":"987654321",
	"name":{ 
           "last_name": "Irvin",
           "first_name": "Ania"
          },
	"age": 20,
	"address":{ 
           "street": "Library Of Congress",
           "city": "DC",
           "state": "Washington",
           "zip": "20559"
           }
},
{
	"ssn":"010101010",
	"name":{ 
           "last_name": "Liana",
           "first_name": "Lukas"
          },
	"age": 30,
	"address":{ 
           "street": "PO Box 96621",
           "city": "DC",
           "state": "Washington",
           "zip": "20120"
           },
	"prescriptions": [
                { id: "RX743009", tradename: "Hydrochlorothiazide"   },
                { id: "RX656003", tradename: "LEVAQUIN", formula: "levofloxacin"  }
               ]

}
]);
print("Collection \"patients\" created and documents inserted.");
print("********************************");

//Part 1.3 - Retrieve and list all patient data
cursor = db.patients.find();
print("Listing all patients:");
while (cursor.hasNext()){
	printjson(cursor.next());
}
print("********************************");

//Part 1.4 - Retrieve the patient document whose age is equal to 20.
cursor = db.patients.find({age: 20});
print("Listing patients with age == 20:");
while (cursor.hasNext()){
	printjson(cursor.next());
}
print("********************************");

//Part 1.5 - Retrieve the patients where age is less than 25.
cursor = db.patients.find({age: {$lt: 25}});
print("Listing patients with age < 25:");
while (cursor.hasNext()){
	printjson(cursor.next());
}
print("********************************");

//Part 1.6 - Using the drop method to delete the entire collection.
print("Dropping table...");
if(db.patients.drop()) {
	print("table dropped");
} else {
	print("table was not dropped");
}
print("********************************");