# Julia programs

## RocPapSci.jl

### Description
Each cell in a [CA](https://en.wikipedia.org/wiki/Cellular_automaton) plays [Rock paper scissors](https://en.wikipedia.org/wiki/Rock_paper_scissors) with its neighbours, at first randomly choosing a strategy. If it's beaten by its neighbours more than it beats them, it adopts their winning strategy next time. Cells are coloured according to their strategy in each generation, e.g. (rock = red, paper = green, scissors = blue) or (black, grey, white). 

I found that within about 200 generations, a 6-generation repeating loop emerges - the same 2 frames repeated with 3 different colourings. The program saves PNG images so a movie or GIF can be made. Making a GIF out of the 6-frame loop at 50fps, and moving your head around in front of the image, particularly closer and further away, produces a remarkable illusion of movement, something like a sci-fi "warp drive" effect. 

### Usage

    $ julia RocPapSci.jl
    
With `MAKE_IMAGES_FOR_GIF = false`, `IMAGES = 260` images are saved in a folder `RPS`. With `MAKE_IMAGES_FOR_GIF = true`, only the last 6 of those images are saved.

Then to make a movie from a lot of images

    $ ffmpeg -f image2 -r 30 -i RPS/RPS%d.png RPS.mp4
    
or a GIF from 6 images

    $ ffmpeg -f image2 -r 50 -loop 0 -i RPS/RPS%d.png RPS.gif
 
### Sample GIFs

To get the full effect, click on an image to see it full screen.

#### 30fps, cell size 3

![gif](https://github.com/yesenadam/Julia-programs/raw/main/images/RPS-RGB-30fps-size3.gif)

#### 50fps, cell size 3

![gif](https://github.com/yesenadam/Julia-programs/raw/main/images/RPS-RGB-50fps-size3.gif)

#### 50 fps, size 2

![gif](https://github.com/yesenadam/Julia-programs/raw/main/images/RPS-RGB-size2-50fps.gif)

### Notes

I think a `CELL_SIZE`>1 works better.

The illusion seems just as strong in greyscale as in colour.

Apparently GIFs work in multiples of 100ths of a second delay between frames. I tried setting framerate to 100 (with `-r 100`) but my browser plays the resulting GIF really slowly. Maybe there's a way of playing them at 100fps.

If you stare at a point of the GIF, the features in your peripheral vision all appear to move around the screen, although they are fixed.

If you look right, it seems you can see waves travelling across the entire screen in NE, SE, SW, NW directions.

The illusion is produced with `FOUR_NABES = false`, which uses a cell's [8 neighbours](https://en.wikipedia.org/wiki/Moore_neighborhood). With `FOUR_NABES = true`, using the [von Neumann neighbourhood](https://en.wikipedia.org/wiki/Von_Neumann_neighborhood), square spirals quickly appear which take over the screen - not so interesting.

Q. What changes of colours, cell size, image rate, make the illusion stronger?

