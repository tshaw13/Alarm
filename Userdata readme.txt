team name: Ctrl Alt Delete
Username.exe:
primary purpose: to let the user enter a username and password and then re-enter them to verify.
scope: It will tell the user whether the re-entered values are the same as the original. If not you can retry. There is also an option to loop when finished to start again.
restrictions/constraints: any string will be accepted, including no input or very short strings or just spaces.
Dependencies/ assumptions: This program requires the masm32 libraries for input and messagebox functionality. It assumes the user can follow instructions.
Technical functionality: The program saves two usernames and passwords to variables. Then it compares them against each other and shows different text depending on whether they are the same or not.