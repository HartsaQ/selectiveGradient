# selectiveGradient
Processing3 (Java) code that reads in an image, that user can change by creating a gradient from a row or a line in the image.

Mouse drag determines area of the gradient. It starts from mouse press and ends at mouse release. Gradient is either vertical or horizontal.
Direction is selected by larger change in x or y coordinate.

There are three different types of gradients:
* gradient where colours change from start line to end line
* gradient that fades to black
* gradient that fades to white

Gradient mode can be changed with keys
* 'b' or 'B' sets gradient to fade to black
* 'w' or 'W' sets gradient to fade to white
* 'g' or 'G' sets gradient to change colour from start line to end line

Image name is given in code. It's assumed that it's a jpg image. With keys 's' or 'S' latest version of the image is saved.
If filename was "image.jpg" saved image is "image1.jpg". Number increases with each save, so it's possible make consecutive changes
and save them to a file. When program starts number is set back to 1, so using same image again causes save to overwrite files from previous runs.
