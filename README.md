# Running the Program

To run this program open within Xcode and ensure that you are using an IOS device simulator. Although it will compile and run for Mac OS devices, the view is not configured for that OS. Once your device is selected, run the program using the play button top left or with the shortcut cmd + R. Enjoy.

# Challenge Outline

For this assignment I chose to create a two player chess game which enforces all legal moves. I decided upon making the game for IOS devices using the 
language Swift. I have some limited experience in Swift already but the real reason I choose to go with Swift and IOS devices is to harness the already 
provided UI and user interaction tools built into Swift.

I decided upon a model view controller design approach. See diagram. Although simple in premise, the challenge came about due to the amount of complicated logic that was needed within enforcing legal moves and the interaction between these three components.

<img width="842" alt="Screenshot 2023-01-04 at 11 09 29" src="https://user-images.githubusercontent.com/92785231/210542667-2e6d4bd6-e731-498e-bc80-033360ebd14f.png">


To start my approach to the project I broke the project into logical smaller tasks / epics, such as “detecting finger touches” or “capturing piece logic”. 
I then made a kanban board to track my progress and visualise outstanding work. 

<img width="981" alt="Screenshot 2023-01-04 at 09 44 00" src="https://user-images.githubusercontent.com/92785231/210527212-7651d162-b532-445a-be41-308489c04c2c.png">

Before starting the development phase of my project I thought about the architecture I was going to use in the program, with the plan to avoid a mass of 
unstructured spaghetti code. I went forward with a model-view-controller, a common architecture for games. This architecture helps us split the UI 
rendering and game logic up which can lead to an easier development process due to clear separation of different parts of the code. 

# Development

Thoughout the development stage I stuck to a few coding conventions, such as naming conventions, spacing, well named and organised files, indents, camel case and also rigorous manual testing after each milestone. I initially wanted to have a series of unit tests testing all functionality but due to time constraints I was unable to achieve this. Instead I made sure to test my code to failiure, trying to find break points to imrpove the quality of my code. I did this through using complicated chess positions, which I knew may cause trouble with my code. 

To begin development I created the main classes for the project. These were the boardView class, gameEngine class and the piece class. Within Swift 
development it is common to have class called viewController, these are used to control various aspects of the view and therefore makes a natural 
controller within my model-view-controller architecture. With the skeleton framework in place for the project I was then able to start to tackle the 
individual epics I had previously thought out.

I started with tackling the epics relating to the UI. I felt that this would be a logical first step and be a good foundation to get stuck into the core 
game logic. My first step was to render a single square to the view. This was achieved through using a UIBezierPath, a predefined class used to define 
paths of shapes. The UIBezierPath holds the location and size information of the shape, which can later be used to render shapes to the screen by 
selecting a fill colour or an outline.

Next my challenge was to render a 64 square board to the view. To do this I created a 2 dimensional array of tuples, the tuples contained the path 
information and also the colour the square should be rendered as. Once the two dimensional array had been constructed it was a simple matter of rendering 
the full 64 square using a nested for loop. 

Once the code was in place and was manually tested to be working, I reflected upon how I had implemented the board rendering. I ended up splitting the 
board rendering into two separate functions, one to create the two dimensional array and another which actually does the rendering to the screen. Although 
this could have been done in a single function I think it makes sense to separate these actions and results in easier to follow code. This can be seen below. 

<img width="1098" alt="Screenshot 2023-01-04 at 11 12 47" src="https://user-images.githubusercontent.com/92785231/210543192-68fefc11-6f75-4d56-a7e0-18fd297e075b.png">

The next step was to render pieces to the screen. To start I created a basic piece class. The class contains information such as the column and row the 
piece is located at, the value of the piece, the colour of the piece and the image to represent the piece. Within the boardView class there is an array 
which holds all current pieces to be displayed. To render an image to the screen we can handily use a predefined function called draw, where we can define 
a shape to render the imagine within. Using the piece’s column and row information we create a square of the same size and location the piece exists on 
within the game. Next we simply loop through the pieces array and render each piece’s image using the data contained within the object. 

After these tasks were completed and I verified manually that they were working, I committed my code to the repo. As part of good development standards I 
wanted to ensure that I was committing code at each passing milestone. A useful tip in case anything were to go wrong within the project, allowing me to 
revert back to a previous tested and stable version if there are any bugs or code breakages. 

The next challenge was to allow the user to move the pieces via touch. Again, I employed a prebuilt function within Swift called touchesBegan. This gave 
me access to the X and Y coordinates for where the touch occurred, which with some simple mathematics I converted into a corresponding column and row 
integer rather than pixel location. To check if the user has touched a piece, I created a function which takes in a column and row integers as well as an 
array of pieces. Using a for loop the function loops through the array, if a piece is found with the respective location the function returns the piece. 
If the user has clicked on a piece, I store those coordinates within an array. The next time a touch is made those coordinates are also stored, there is 
now enough information for a move to be made. A starting location a desired destination. 

The next task was to make use of the captured coordinates to physically move the pieces. I decided that this logic should not be part of the view class but instead the model class, which should handle the game logic. The model also contains an array of pieces, for it to perform the game logic upon. I created a function, ingeniously named movePiece, which takes in four integers; a start column and row and a desired column and row the user wants to relocate a piece to. I simply find the piece located at the start coordinates and update their coordinates to the desired destination. The controller then updates the view’s pieces array to the models array and sets the screen to be re-rendered and the pieces now move! 

An issue now arises though, when a user moves a piece to a square which already contains a piece. One piece was rendered above an another leading to a host of bugs and problems. In real life this isn’t an issue, the player simply removes the piece from the board and replaces it with their piece. The same 
logic applies within my program too. If the target square contains a piece, I remove it from the pieces array, update the starting piece’s coordinates and 
the controller sets the view to be updated and now piece capturing is implemented. To prevent a user from capturing their own pieces, I only remove pieces 
of the opposite colour to the piece being moved. This is done by checking the isWhite boolean in both pieces, if they are not equal a capture is made. 

In its current state my project can almost be used to play a full game of chess. The pieces move freely across the board and are able to capture one 
another. But there is no logic as of yet to stop a user from making illegal moves, or even stop a user making multiple moves in a row. To ensure that each 
player only takes one turn at a time I added a boolean to my gameEngine called isWhitesTurn. Before a move is made I check if isWhitesTurn is equal to the 
isWhites boolean of the prospective moving piece, if they are the same a move can be made. This boolean is then flipped after each move is made. 

The next epic to tackle was making ensuring that the pieces moved correctly. I saw piece movement as a single epic, which can be easily broken down into 
the individual pieces. I started with the knight. To started I created a function called isLegalMove which returns a boolean. Within the function I check 
if each move obeys the rules of chess. The function takes in four integers representing the starting square and desired square, the isWhitesTurn boolean 
and an array of pieces. I decided that it made sense to have the legality checks within their own function, rather than within the movePiece function 
itself. 

Finding the possible moves for a knight is a rather simple task as it only ever has at max 8 potential squares it can jump too. I create a function to 
handle this which takes in two integers to represent the starting location. Using these two integers I can add all the possible moves to an array, a move 
is represented as a tuple of an X and Y coordinate. As it possible I added a move which extends outside of the boards bounds, I then filter said array and 
check each move is within the bounds of the 64 squares. I also check whether the target square contains a piece of the same colour, this of course would 
not be a legal square to move to. The array of possible squares the knight can move to is then returned. 

<img width="1082" alt="Screenshot 2023-01-04 at 11 14 21" src="https://user-images.githubusercontent.com/92785231/210543462-664f93bc-455f-42b7-b72e-0ff5a5c83183.png">


Within the isLegalMove function I look up the piece on the starting square and check it’s value. If it is a knight I call the findLegalKnightMoves 
function and check whether the move the user wants to make is within the possible moves of the knight. If not we return false to indicate that it is not 
a legal move and the move function will not make the move. 

Next I work on the bishop movement logic, which naturally I create a separate function for. Bishops can only move diagonally from the square they are 
currently on. To program this I used four separate loops, one to go diagonally up to the right, one to go diagonally up to the left, one to down 
diagonally to the left and one to go diagonally down to the right. Each square the loops come across it added to an array of possible moves. 
With each iteration of the loop I check whether the square in question contains a piece, of either colour. If the square does contain a piece I then break 
out of the loop. I do this because bishops don’t posses X-ray powers, once they encounter a piece they cannot travel through. Though the array may now 
contain potential target squares which have a piece of the same colour on. To solve this issue I loop through the possible moves array and check each 
square, if it contains a piece of the same colour it is filtered out. 

<img width="753" alt="Screenshot 2023-01-04 at 11 14 56" src="https://user-images.githubusercontent.com/92785231/210543532-08afc546-7d31-4a01-8c5c-4a46ab8e9b7d.png">


The next piece to tackle was the rooks. They move orthogonally any number of squares that they like. I do this in much the same way that I did for the 
bishops, with four separate loops. Though instead of looking diagonally I just look up, down, left and right this time. Again I check whether the 
potential square contains a piece and if it does we break out of the loop. Again like the bishops, the possible move array might contain squares which 
already have a piece of the same colour. These are filtered out by looping through the array and making the same check as with the bishops. 

<img width="761" alt="Screenshot 2023-01-04 at 11 15 21" src="https://user-images.githubusercontent.com/92785231/210543603-cddc3332-dd91-4633-b490-9bfeee750519.png">


With the bishop and rook movement logic in place finding the legal moves for the queen is easy. The queen can move both diagonally like bishops and 
orthogonally like a rook. I create a separate function to find the queen’s moves and simply call both the bishop function and the rook functions and add 
the results to a single array which is then returned. 

<img width="916" alt="Screenshot 2023-01-04 at 11 15 40" src="https://user-images.githubusercontent.com/92785231/210543650-982f5652-d121-4481-84d9-6b1a64a55cc5.png">


The king, much like the knight, has only 8 possible moves max at any one time. It can only move one square at a time in any direction. So I decided to hard code these possible moves into an array, the same as I did with the knight. Then I loop through the array and check whether any of the moves extend 
outside of the bounds of the board or if square contains a piece of the same colour, these are then filtered out of the final result much like I have done 
before. 

The final piece was the humble pawn. Which unlike the other pieces has various ways it can move! It typically moves one square forwards at a time, but on 
it’s starting move it has the option to move two squares at once. Just to complicate matters even more it attack diagonally, not forwards. To start I 
check the colour of the piece, this dictates the direction the pawn can travel. I then check the square in front of the pawn, if it is empty I add it to a 
possible move array. If the pawn is on the starting square I then check whether the square two squares in front of our pawn is empty, if it is I add it to 
the possible moves. Next I must check the squares diagonally in front of the pawn, if either of them contain a piece of the opposite colour the square is 
also added to the possible moves. Finally I loop through the possible moves and check that each move is within the bounds of the board. 

<img width="686" alt="Screenshot 2023-01-04 at 11 16 22" src="https://user-images.githubusercontent.com/92785231/210543740-5c3fd097-44b9-4f4f-a0d0-a2e76ae2beac.png">


The next epic to undertake was castling. Castling involves two moves to get the king to safety. The king moves two squares either left of right and the 
rook then lands next to the king. It was not possible do this using my previous move function, due to that function flipping who’s turn it is after each 
move and I need to make two moves in a row for the same player. To do this I created two separate functions, one to handle castling long and the other 
for castling short. They both check whether the squares in-between king and rook are free of pieces. I also had to add a new variable to the piece class
called hasMoved, a boolean. This was nessecary as you can only castle if neither rook or king have moved. If both or these conditions are met then we update the cordinates of the rook and king. 

<img width="583" alt="Screenshot 2023-01-04 at 11 17 16" src="https://user-images.githubusercontent.com/92785231/210543893-9029a4fe-d960-4143-8645-64427952391d.png">


With all the piece movement inplace the next major epic to tackle was the idea of check. A vital element of the game. To do this I created a function which finds all squares which are under attack from one players set of pieces. This is done by finding all the possible squares all the pieces can move to then we loop through all of these squares and see whether the players king is on any of them, if it is then the king must be in check. Upon a later review I move the logic to find all attacked squares to a seperate function. 


Next was to make sure that being in check restricted the players move. When in check the player must make a move to get out of check. To solve this problem I created the below function. This function takes a move and psuedo plays it. It then checks whether the player is still in check using the previous function and returns a boolean as to whether the move is effective and getting the player out of check or not. Within the earlier makeMove function we check if the player is in check, if they are we then check if their proposed move gets them out of check. If it does, it is a legal move and is playable. 

<img width="1013" alt="Screenshot 2023-01-04 at 09 40 34" src="https://user-images.githubusercontent.com/92785231/210526598-fe626302-d2e4-4308-ab08-2cfef3ed6ff7.png">

Another aspect of chess is that it is illegal to make a move which puts you in check. I solved this in much the same way as the previous challenge. Before a move is made, I psuedo make that move in a seperate function and check whether the move will have put the player into check. If it does put the player into check, it is an illegal move and therefore cannot be played. 

Through some extensive manual testing and by looking at positions I knew may cause trouble I had found I had some problems with my castling logic. In chess the king may not castle when in check and it also may not pass through check. Meaning that if an enemy piece is attacking one of the squares between the king and the rook, castling is not legal. To solve this I used the previous function which finds all attacked squares and check whether the squares between the rook and king are under attack. If they are, then castling is not permitted. 

Finally the last major epic was making sure the game could be won or drawn via stalemate. This was quite easy though through code I had written previously. At the end of each move we can make a check whether the opponent is in check, if they are we calculate all of their possible legal moves. If they have zero legal moves and are in check, then game over checkmate has been achieved. Otherwise if the opponent is not in check but has no possible moves either, then stalemate has been reached and the game is drawn. 

# Evaluation

Although I am incredibly proud of what I have achieved, my code does have some significant smells. I have several functions which need serious refactoring. They are extremely long and contain confusing and heavily indented code. An example of this can be found below. This function is so long infact it is impossible for me to capture it all in one screenshot. It can most definitely be described as a God function. This function needs some heavy refactoring. The function handles too many different aspects of the game, such as registering the moves the player wants to make and highlighting squares. Ideally we want a function to have a single purpose. This makes our code more readable but perhaps more importantly it makes our code more maintainable. 

<img width="790" alt="Screenshot 2023-01-04 at 09 59 34" src="https://user-images.githubusercontent.com/92785231/210530235-f6f1470b-4bcf-4199-b69e-7c1ee9a20df0.png">

Another major smell my code exudes is the fact that as the project went on the seperation between model and view became blurred. This was really due to time contraints and an eagerness to have a working project finished. An example can be seen below. This is within the view component. We can see that the view is doing checks such as whether a move and if the game is over or not. This is logic that should be handled by the view component, who's sole purpose is to display data. This logic should be handled by the model, which in turn should pass that data back to the view for rendering. Having this blurred line between the different components can cause complications if bugs arise. 

<img width="1262" alt="Screenshot 2023-01-04 at 10 19 50" src="https://user-images.githubusercontent.com/92785231/210534006-d68d7fd2-60de-4b30-9e82-a7e4d06296e3.png">

One advanced programming technique I used was inheritance and protocols, which are a native feature in Swift. This can be seen below. We can see that my view controller inherits from two classes, UIViewController and MoveDelegate. The former is done automatically by Swift. The MoveDelegate is a protocol that I created. A protocol can be thought of as a strict blueprint for any class which inherits from it. The child class must comply to the protocol, or in other words the protocol delegates to the child class certain attributes. Although not strictly nessercary, it is a good way to define how a class should work before working on the implementation and harnessing Swift to ensure our classes are correct. 

<img width="707" alt="Screenshot 2023-01-04 at 10 25 08" src="https://user-images.githubusercontent.com/92785231/210535479-bc235e53-3a6d-48be-b005-213942c53de5.png">

<img width="518" alt="Screenshot 2023-01-04 at 10 29 35" src="https://user-images.githubusercontent.com/92785231/210535696-de3b8925-6cc5-4f45-b575-249fa1eb6889.png">

The code I am most proud of isn't a single function but a few around how I handle the idea of check. The below function is used across my program, it removes any illegal moves from an array of potential moves. This is a crucial piece of code and prevents the user from making a move which either puts them into check, or when in check it prevents them from making a non relevant move. It is also used within the view component when highlighting potential viable squares to move a piece to, I did not want to highlight squares which would be deemed illegal. 

<img width="1054" alt="Screenshot 2023-01-04 at 10 41 15" src="https://user-images.githubusercontent.com/92785231/210537763-39602189-bd85-4cb7-b644-c7ffd943a5a5.png">

Overall I am proud of what I was able to achieve. But there are some issues that if given more time I would like to address. To begin with there are many areas of code which need refactoring. Many functions are too long and there is a heavy level of intendation throughout the code base. Part of this is also due to how Swift handles optionals and maybe down to my inexperience with the language. The organisation of my project also needs significant work. There are many freestanding functions, which are seperated into their own logical files. This occoured due to the breakdown of the model view controller. Ideally most of these functions should be contained within the gameEngine class, as they are core game logic. This would take significant refactoring though of both the files and the model view controller architecture. 

There are also some features that I have not added such as en passant. This could be achieved by storing the square behind a pawn after it moves forward two squares in a seperate variable. On the next turn I could then check if a pawn is attacking the en passant square, if it is then I could add it to the array of possible moves for the pawn. Another feature I missed out regarding pawns is promotion to any piece. It is most common in chess to promote a pawn to the queen, usually leading to victory. Though in some rare cases a player may choose to under promote to a knight or bishop for example. 

Finally one of the major features I missed out is other ways to draw the game. Stalemate is the only way for a game to end in a draw. Draws also occour when both players have insuffecient pieces to deliver checkmate. For example if both players only have a king remaining, the game is drawn. Though there are other positions and examples. This could be solved in the checkIfGameOver function. In the function we can check the array which holds the all current pieces. If for example there is only two kings remaining, we know the game is a draw. Or another example if a player only has a king and a knight and the other player only has a king, we also know the game is a draw. 

Finally games can be drawn through repitition. This is a rather common tactic in chess, especially if you are in a losing position. If you are in a losing position you can sometimes force a draw through a forced line of repitition, after 3 moves of repitition the game is drawn. To solve this I would need to store every move made during the game in some kind of data structure, probably an array. Again in the checkIfGameOver function we look at the last three moves made and if they are repeating we know the game is drawn. 


