using Images, Printf
#white, grey, black
const COLOUR = [RGB(1,1,1),RGB(0.5,0.5,0.5),RGB(0,0,0)]
#orig red, green, blue
#const COLOUR = [RGB(1,0,0),RGB(0,0.5,0),RGB(0,0,1)]

# 0= Rock, 1= Paper, 2= Scissors... n beats n-1, n loses to n+1.

#if true, only save the last 10 images after gen 250. Only 6 are needed to make a gif.
const MAKE_IMAGES_FOR_GIF = true

#CELL_SIZE is the size of the 'pixels' in the image.. use 2,5,10 etc, a num that divides the HEI and WID of image.
const CELL_SIZE = 3 #2
const IMAGE_WID = 1920
const IMAGE_HEI = 1080
const CELL_ARRAY_WID = Int64(IMAGE_WID/CELL_SIZE)
const CELL_ARRAY_HEI = Int64(IMAGE_HEI/CELL_SIZE)
initial_cells = rand(0:2,CELL_ARRAY_HEI,CELL_ARRAY_WID)
const NUMBER_OF_IMAGES = 260

save_images(initial_cells,NUMBER_OF_IMAGES)

#NB! This is a bad way of doing it, testing every time that +/-1 wont go over edge. instead just call get_result with good x & y vals.
#or just use mod(xx,CELL_ARRAY_WID) instead of xx etc. then also dont need to use xx,yy at all, just use a and b.
function get_result(x::Int64,y::Int64,cells)
    wins = 0
    losses = 0
    self = cells[y,x]

    #NB!!!! have different funcs for 4Nabe and 8Nabe versions.
    #just do each cell explicitly, its faster... no testing if its right.
    #have a function to convert cells to tHEIr proper version (i.e. if >WID then = 1 etc.)
    #that func only works if the point moves max 1 outside image...
    #write another func that can handle any amount of outsideness....... and with any minx, maxx etc...
    #e.g. if allowed range is 50 to 80, then 85 should be 55? and 45 goes to 75... (i think these are 1 off)
    #that will be a super-useful func. similar to frac()
    for a = x-1:x+1
        xx = a
        if xx > CELL_ARRAY_WID
            xx = 1
        elseif xx < 1
            xx = CELL_ARRAY_WID::Int
        end
        for b = y-1:y+1
            if a == x && b == y #dont do self cell
                continue
            end

            # # ******** this bit for 4-neighbours.. without it, 8 nabes. *******************
            # if a != x && b != y # ie not on the horiz-vert axis through cell that 4-nabes are on...
            #     continue
            # end

            yy = b
            if yy > CELL_ARRAY_HEI
                yy = 1
            elseif yy < 1
                yy = CELL_ARRAY_HEI::Int
            end
            if mod(cells[yy,xx]-1,3) == self
                losses += 1
            elseif mod(cells[yy,xx]+1,3) == self
                wins += 1
            end
        end
    end
    if losses > wins         #e.g. rock can only change to paper, and does so if losses to paper > wins over scissors
        return mod(self+1,3)
    else return self
    end
end

function save_big_image(image_num,cells)
    image = fill(RGB(0,0,0),CELL_ARRAY_HEI*CELL_SIZE,CELL_ARRAY_WID*CELL_SIZE)
    for (cells_x,image_x) = zip(0:CELL_ARRAY_WID-1 , 0:CELL_SIZE:IMAGE_WID-1)
        for (cells_y,image_y) = zip(0:CELL_ARRAY_HEI-1 , 0:CELL_SIZE:IMAGE_HEI-1)
            px = COLOUR[ cells[cells_y+1,cells_x+1] +1] #0..2 => 1..3
            for i = 1:CELL_SIZE, j = 1:CELL_SIZE
                image[image_y+j,image_x+i] = px
            end
        end
    end
    ofile = @sprintf("RPS/RPS%d.png",image_num)
    save(ofile,image)
end

function save_images(cells,number_of_images) 
    save_big_image(0,cells)
    for i = 1:number_of_images
        @printf("Doing image %d..\n",i)
        new_cells = [Int64(get_result(x,y,cells)) for y = 1:CELL_ARRAY_HEI::Int,x = 1:CELL_ARRAY_WID::Int]
        cells = copy(new_cells)
        if MAKE_IMAGES_FOR_GIF
            if i>250
                save_big_image(i-251,cells)
            end
        else
            save_big_image(i,cells)
    end
end
