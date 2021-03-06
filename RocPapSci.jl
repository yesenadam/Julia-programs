using Images, Printf
# uncomment for white, grey, black
# const COLOUR = [RGB(1,1,1),RGB(0.5,0.5,0.5),RGB(0,0,0)]
# OR uncomment for red, green, blue
const COLOUR = [RGB(1,0,0),RGB(0,0.5,0),RGB(0,0,1)]

# 0= Rock, 1= Paper, 2= Scissors... n beats n-1, n loses to n+1.

# if true, only save the last 6 images.
const MAKE_IMAGES_FOR_GIF = false #true
# true -> use Von N neighbourhood, 4 neighbours. false -> Moore neighbourhood, 8 neighbours.
const FOUR_NABES = false 

# CELL_SIZE is the width and height in pixels of the large 'pixels' in the image.
# use 2,5,10 etc - must be a num that divides IMAGE_HEI and IMAGE_WID.
const CELL_SIZE = 3 #2
const IMAGE_WID = 1920
const IMAGE_HEI = 1080
const CELL_ARRAY_WID = Integer(IMAGE_WID/CELL_SIZE)
const CELL_ARRAY_HEI = Integer(IMAGE_HEI/CELL_SIZE)
const INITIAL_CELLS = rand(0:2, CELL_ARRAY_HEI, CELL_ARRAY_WID)
const IMAGES = 260

mod1(n,modulus) = mod(n-1,modulus)+1  # given n, returns a number in 1 .. modulus

function calculate_winner(x::Integer,y::Integer,cells)
    wins = 0
    losses = 0
    self = cells[y,x]
    for nabe_x in [mod1(x-1, CELL_ARRAY_WID), x, mod1(x+1, CELL_ARRAY_WID)],
      nabe_y in [mod1(y-1, CELL_ARRAY_HEI), y, mod1(y+1, CELL_ARRAY_HEI)] 
        # dont play against yourself
        nabe_x == x && nabe_y == y && continue 
        # diagonal neighbours arent von N neighbours
        FOUR_NABES && nabe_x != x && nabe_y != y  && continue

        if mod(cells[nabe_y,nabe_x]-1, 3) == self # e.g. rock loses to neighbouring paper
            losses += 1
        elseif mod(cells[nabe_y,nabe_x]+1, 3) == self # e.g. paper beats neighbouring rock 
            wins += 1
        end
    end
    
    # if beaten, adopt the strategy that beat it
    # e.g. rock can only lose to paper, and does so if losses to paper > wins over scissors
    return losses > wins ? mod(self+1, 3) : self
end

function save_image(image_num,cells)
    image = fill(RGB(0,0,0), IMAGE_HEI, IMAGE_WID)
    for (cells_x,image_x) in zip(0:CELL_ARRAY_WID-1, 0:CELL_SIZE:IMAGE_WID-1),
      (cells_y,image_y) in zip(0:CELL_ARRAY_HEI-1, 0:CELL_SIZE:IMAGE_HEI-1)
        px = COLOUR[cells[cells_y+1, cells_x+1]+1] #0..2 => 1..3
        for i in 1:CELL_SIZE, j in 1:CELL_SIZE
            image[image_y+j, image_x+i] = px
        end
    end
    save(@sprintf("RPS/RPS%d.png",image_num),image)
end

function save_images(cells) 
    save_image(0,cells) #but it saves over this if MAKE_IMAGES_FOR_GIF
    for image_num in 1:IMAGES
        @printf("Doing image %d..\n",image_num)
        cells = [Integer(calculate_winner(x,y,cells)) for y = 1:CELL_ARRAY_HEI::Int, 
            x = 1:CELL_ARRAY_WID::Int]
        if MAKE_IMAGES_FOR_GIF  # save 6 images for the GIF loop
            if image_num>IMAGES-6
                save_image(image_num-IMAGES+5, cells)
            end
        else
            save_image(image_num,cells)
        end
    end
end

save_images(INITIAL_CELLS)
