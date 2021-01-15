# Julia programs

## RocPapSci.jl

### Description
Each cell in a [CA](https://en.wikipedia.org/wiki/Cellular_automaton) plays [Rock paper scissors](https://en.wikipedia.org/wiki/Rock_paper_scissors) with its neighbours, at first randomly choosing a strategy. If it's beaten by its neighbours more than it beats them, it adopts their winning strategy next time. Cells are coloured according to strategy in each generation, e.g. (Red, Green, Blue) or (Black, Grey, White). 

I found that within about 250 generations, a 6-generation repeating loop emerged - the same 2 frames repeated with 3 different colourings. The program saves png images so a movie or GIF can be made. Making a GIF out of the 6-frame loop at 50fps, and moving your head around in front of the image, produces a remarkable illusion of movement, something like sci-fi warp drive effect. 

### Usage

    $ julia RocPapSci.jl
    
With `MAKE_IMAGES_FOR_GIF = false`, `IMAGES` images are save in a folder `RPS`. With `MAKE_IMAGES_FOR_GIF = true`, only the last 6 images are saved.

Then to make a movie from a lot of images

    $ ffmpeg -f image2 -r 30 -i RPS/RPS%d.png RPS.mp4
    
or a GIF from 6 images

    $ ffmpeg -f image2 -r 50 -loop 0 -i RPS/RPS%d.png RPS.gif
 
### Notes

I think a `CELL_SIZE`>1 works better.

The illusion seems just as strong in greyscale as in colour.

Apparently GIFs work in multiples of 100ths of a second delay between frames. I tried setting framerate to 100 (with `-r 100`) but my browser plays the resulting GIF really slowly. Maybe there's a way of playing them at 100fps.



