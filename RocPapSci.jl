using Images, Printf
#white, grey, black
const COLOUR = [RGB(1,1,1),RGB(0.5,0.5,0.5),RGB(0,0,0)]
#orig red, green, blue
#const COLOUR = [RGB(1,0,0),RGB(0,0.5,0),RGB(0,0,1)]

# 0= Rock, 1= Paper, 2= Scissors... n beats n-1, n loses to n+1.


#NB!! There's a lot of over-specifying types in this program. Be vaguer, i.e. Integer not Int64 when possible, or nothing at all if possible.


#if true, only save the last 10 images after gen 250. Only 6 are needed to make a gif.
const MAKE_IMAGES_FOR_GIF = true
const FOUR_NABES = false # true -> use Von N neighbourhood, i.e. 4 neighbours. false -> Moore neighborhood - 8 neighbours.

#CELL_SIZE is the size of the large 'pixels' in the image.. use 2,5,10 etc, a num that divides the HEI and WID of image.
const CELL_SIZE = 3 #2
const IMAGE_WID = 1920
const IMAGE_HEI = 1080
const CELL_ARRAY_WID = Int64(IMAGE_WID/CELL_SIZE)
const CELL_ARRAY_HEI = Int64(IMAGE_HEI/CELL_SIZE)
initial_cells = rand(0:2, CELL_ARRAY_HEI, CELL_ARRAY_WID) #NB! this is const...
const NUMBER_OF_IMAGES = 260

#this line does all the work
save_images(initial_cells,NUMBER_OF_IMAGES)

function mod1(n,modulus)
    #given n, returns a number in 1 .. modulus
    return mod(n-1,modulus)+1
end

function calculate_winner(x::Int64,y::Int64,cells)
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

    for nabe_x in [mod1(x-1, CELL_ARRAY_WID), x, mod1(x+1, CELL_ARRAY_WID)]
        for nabe_y in [mod1(y-1, CELL_ARRAY_HEI), y, mod1(y+1, CELL_ARRAY_HEI)] 
            if nabe_x == x && nabe_y == y #dont do self cell
                continue
            elseif FOUR_NABES
                if nabe_x != x && nabe_y != y # ie not on the horiz-vert axis through cell that 4-nabes are on...
                    continue
                end
            end

            # rock loses to neighbouring paper, paper loses to scissors, scissors loses to rock
            if mod(cells[nabe_y,nabe_x]-1, 3) == self 
                losses += 1
            # paper beats neighbouring rock, scissors beats paper, rock beats scissors
            elseif mod(cells[nabe_y,nabe_x]+1, 3) == self 
                wins += 1
            end
        end
    end
    
    #e.g. rock can only change to paper, and does so if losses to paper > wins over scissors
    return if losses > wins         
        mod(self+1, 3)
    else 
        self
    end
end

function save_image(image_num,cells)
    image = fill(RGB(0,0,0), CELL_ARRAY_HEI*CELL_SIZE, CELL_ARRAY_WID*CELL_SIZE)
    for (cells_x,image_x) in zip(0:CELL_ARRAY_WID-1 , 0:CELL_SIZE:IMAGE_WID-1)
        for (cells_y,image_y) in zip(0:CELL_ARRAY_HEI-1 , 0:CELL_SIZE:IMAGE_HEI-1)
            px = COLOUR[ cells[cells_y+1, cells_x+1] +1] #0..2 => 1..3
            for i in 1:CELL_SIZE, j in 1:CELL_SIZE
                image[image_y+j, image_x+i] = px
            end
        end
    end
    #NB! not ofile, just ofile name
    ofile = @sprintf("RPS/RPS%d.png",image_num)
    save(ofile,image)
end

function save_images(cells,number_of_images) 
    save_image(0,cells)
    for i in 1:number_of_images
        @printf("Doing image %d..\n",i)
        #NB! Can I just say, cells = [...] instead of next 2 lines? is new_cells needed?
        new_cells = [Int64(calculate_winner(x,y,cells)) for y = 1:CELL_ARRAY_HEI::Int, x = 1:CELL_ARRAY_WID::Int]
        cells = copy(new_cells)
        if MAKE_IMAGES_FOR_GIF
            if i>NUMBER_OF_IMAGES-10
                save_image(i-NUMBER_OF_IMAGES+9, cells)
            end
        else
            save_image(i,cells)
    end
end
