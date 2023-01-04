Chess Read me


Challenge Outline

For this assignment I chose to create a two player chess game which enforces all legal moves. I decided upon making the game for IOS devices using the 
language Swift. I have some limited experience in Swift already but the real reason I choose to go with Swift and IOS devices is to harness the already 
provided UI and user interaction tools built into Swift.

I decided upon a model view controller design approach. See diagram. 


To start my approach to the project I broke the project into logical smaller tasks / epics, such as “detecting finger touches” or “capturing piece logic”. 
I then made a kanban board to track my progress and visualise outstanding work. 

Insert diagram here. 

Before starting the development phase of my project I thought about the architecture I was going to use in the program, with the plan to avoid a mass of 
unstructured spaghetti code. I went forward with a model-view-controller, a common architecture for games. This architecture helps us split the UI 
rendering and game logic up which can lead to an easier development process due to clear separation of different parts of the code. 

2. Development

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
this could have been done in a single function I think it makes sense to separate these actions and results in easier to follow code. 

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

The next task was to make use of the captured coordinates to physically move the pieces. I decided that this logic should not be part of the view class but
instead the model class, which should handle the game logic. The model also contains an array of pieces, for it to perform the game logic upon. I created 
a function, ingeniously named movePiece, which takes in four integers; a start column and row and a desired column and row the user wants to relocate a 
piece to. I simply find the piece located at the start coordinates and update their coordinates to the desired destination. The controller then updates 
the view’s pieces array to the models array and sets the screen to be re-rendered and the pieces now move! 

An issue now arises though, when a user moves a piece to a square which already contains a piece. One piece was rendered above an another leading to a host
of bugs and problems. In real life this isn’t an issue, the player simply removes the piece from the board and replaces it with their piece. The same 
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

The next piece to tackle was the rooks. They move orthogonally any number of squares that they like. I do this in much the same way that I did for the 
bishops, with four separate loops. Though instead of looking diagonally I just look up, down, left and right this time. Again I check whether the 
potential square contains a piece and if it does we break out of the loop. Again like the bishops, the possible move array might contain squares which 
already have a piece of the same colour. These are filtered out by looping through the array and making the same check as with the bishops. 

With the bishop and rook movement logic in place finding the legal moves for the queen is easy. The queen can move both diagonally like bishops and 
orthogonally like a rook. I create a separate function to find the queen’s moves and simply call both the bishop function and the rook functions and add 
the results to a single array which is then returned. 

The king, much like the knight, has only 8 possible moves max at any one time. It can only move one square at a time in any direction. So I decided to hard
code these possible moves into an array, the same as I did with the knight. Then I loop through the array and check whether any of the moves extend 
outside of the bounds of the board or if square contains a piece of the same colour, these are then filtered out of the final result much like I have done 
before. 

The final piece was the humble pawn. Which unlike the other pieces has various ways it can move! It typically moves one square forwards at a time, but on 
it’s starting move it has the option to move two squares at once. Just to complicate matters even more it attack diagonally, not forwards. To start I 
check the colour of the piece, this dictates the direction the pawn can travel. I then check the square in front of the pawn, if it is empty I add it to a 
possible move array. If the pawn is on the starting square I then check whether the square two squares in front of our pawn is empty, if it is I add it to 
the possible moves. Next I must check the squares diagonally in front of the pawn, if either of them contain a piece of the opposite colour the square is 
also added to the possible moves. Finally I loop through the possible moves and check that each move is within the bounds of the board. 

The next epic to undertake was castling. Castling involves two moves to get the king to safety. The king moves two squares either left of right and the 
rook then lands next to the king. It was not possible do this using my previous move function, due to that function flipping who’s turn it is after each 
move and I need to make two moves in a row for the same player. To do this I created two separate functions, one to handle castling long and the other 
for castling short. They both check whether the squares in-between king and rook are free of pieces. I also had to add a new variable to the piece class
called hasMoved, a boolean. This was nessecary as you can only castle if neither rook or king have moved. 
