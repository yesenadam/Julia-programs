using Images, Printf
const ind=[RGB(1,1,1),RGB(0.5,0.5,0.5),RGB(0,0,0)]
#orig R,G,B
#const ind=[RGB(1,0,0),RGB(0,0.5,0),RGB(0,0,1)]
#0=Rock,1=Paper,2=Scissors... n beats n-1, n loses to n+1.

function GetResult(x::Int64,y::Int64,img)
    Wins=0#wins
    Losses=0 #losses
    self=img[y,x]

    #NB!!!! have different funcs for 4Nabe and 8Nabe versions.
    #just do each cell explicitly, its faster... no testing if its right.
    #have a function to convert cells to their proper version (i.e. if >wid then = 1 etc.)
    #that func only works if the point moves max 1 outside image...
    #write another func that can handle any amount of outsideness....... and with any minx, maxx etc...
    #e.g. if allowed range is 50 to 80, then 85 should be 55? and 45 goes to 75... (i think these are 1 off)
    #that will be a super-useful func. similar to frac()
    for a=x-1:x+1
        xx=a
        if xx>wid
            xx=1
        elseif xx<1
            xx=wid::Int64
        end
        for b=y-1:y+1
            if a==x && b==y #dont do self cell
                continue
            end

            # # ******** this bit for 4-neighbours.. without it, 8 nabes. *******************
            # if a!=x && b!=y # ie not on the horiz-vert axis through cell that 4-nabes are on...
            #     continue
            # end

            yy=b
            if yy>hei
                yy=1
            elseif yy<1
                yy=hei::Int64
            end
            if mod(img[yy,xx]-1,3)==self
                Losses+=1
            elseif mod(img[yy,xx]+1,3)==self
                Wins+=1
            end
#            if x==4 && y==2
 #               @printf("a %d b %d xx %d yy %d self %d img[yy,xx] %d Wins %d Losses %d\n",a,b,xx,yy,self,mod(img[yy,xx],3),Wins,Losses)
  #          end
        end
    end
 #   @printf("x %d y %d self %d Losses %d Wins %d\n",x,y,self,Losses,Wins)
    if Losses>Wins         #e.g. rock can only change to paper, and does so if losses to paper > wins over scissors
        return mod(self+1,3)
    else return self
    end
end

function SaveBigImg(num,ary)
    #cellSize is the size of the 'pixels' in the image.. use 2,5,10 etc, a num that divides the hei and wid of image.
    bigAry=fill(RGB(0,0,0),hei*cellSize,wid*cellSize)
    bigX=0
    for x=0:wid-1
        bigY=0
        for y=0:hei-1
            px=ind[ary[y+1,x+1]+1] #0..2 => 1..3
            for i=1:cellSize::Int64
                for j=1:cellSize
                    bigAry[bigY+j,bigX+i]=px
                end
            end
 #using that loop is about 20% faster than this: at least for cellSize=2..
 #           bigAry[bigY+1:bigY+cellSize,bigX+1:bigX+cellSize].=px
            bigY+=cellSize
        end
        bigX+=cellSize
    end
    ofile=@sprintf "RPS/RPS%d.png" num
    save(ofile,bigAry)
end

function SaveImages(img,num)
    SaveBigImg(0,img)
    for i=1:num
        @printf("Doing image %d..\n",i)
        newImg=[Int64(GetResult(x,y,img)) for y=1:hei::Int64,x=1:wid::Int64]
        img=copy(newImg)
        if i>250 #this test ONLY for making GIFs!!!!!! remove to make movies.
            SaveBigImg(i,img)
        end
    end
end

const cellSize=3 #2
wid=Int64(1920/cellSize)
hei=Int64(1080/cellSize)
img=rand(0:2,hei,wid)
numImages=260
SaveImages(img,numImages)
