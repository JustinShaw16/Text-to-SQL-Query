1. With the help of chatgpt I was able to create the frontend of Project02 using the Angular frontend framework. ChatGPT was able to generate the framework of how Angular runs and showed me how to scaffold the app, which allowed me to route to communicate with my backend.
ChatGPT also helped in implementing how Angular features, such as pagesize and login Dialog.
I also had to ask ChatGPT for help on creating the user prompt box and adding the example list.
There were also many clarifications that I wanted to know that I got from ChatGPT throughout the project.


2. While building the frontend through angular I had to split it into three components
1. query component - features
   1. Schema text: displayed the schema that users can use while coming up with the prompt
   2. Example list: a list of 3 different prompts that a user can click on and automatically is inserted into the user prompt box
   3. User prompt box: allows the user to input a prompt that the LLM would later create a query on
   4. Submit button: once the user enters a prompt into the query the submit button will light up and indicate that its ready to go to the LLM. After hitting the button it will prompt the user with a login pop up.
2. login query - features
   1. NetID insert: the user will have to enter their net id into the Netid text box
   2. Password: the user will have to enter their password into the password text box. Note that while inputting the password, it is censored with dots so nobody can see it.
   3. Cancel button: if the user does not want to enter their information they can hit cancel. However the application does not move on to the result page and will not do it until the Netid and password is entered.
   4. OK button: when the user is done entering their Netid and password, it will store and use their Netid password to login to the Ilab computer. Then it will prompt the user with a “loading response…” while it generates a query through the LLM
3. results component - features
   1. Original query text: it will display the prompt that you gave to the LLM 
   2. Generated SQL text: it will display the sql query that the LLM generated and correctly format it to just the query
   3. Results: show the generated result after loading the ilab_script.py which is on the Ilab computer with the generated query that the LLM gave and returns the correct information
      1. Results Table: It will either display the data where the first letter of each item is alphabetically arranged or if it is numbers will correctly put it in order. Also it will generate multiple columns if the query selects multiple columns
         1. Search filter: you can type anything into the text box and if that text is within the table, it will show only those items
         2. Items per page dropdown: you are able to choose between seeing 5, 10, or 15 rows in the table at a time
         3. Number of pages: you are able cycle between all pages or either skip to the first page or skip to the last page












To host the Angular frontend you must put this into the terminal:
cd ~/Desktop/Project02
python3 -m uvicorn database_llm:app --reload --port 8000


In a different terminal tab type:
cd ~/Desktop/Project02/db_llm_frontend
npm start


Then go to the website given after typing “npm start” in any browser