pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
--killing of the dead
--by jerkstore


function _init()

 poke(0x5f2d, 1)
 resetgame()
 menuitem(1,"suicide", function() hero.hp=-1 end) 
 
 
end

function _update()
 if (player.gamescene=="intro") then intro_update() end
 if (player.gamescene=="death") then death_update() end
end

function _draw()
 if (player.gamescene=="intro") then intro_draw() end
 if (player.gamescene=="death") then death_draw() end
end

function resetgame()
 music(0)
 t=0
 test=0
 elitec=2
 player={}
 hero={}
 bullets={}
 hasbombed=false
 fire=1
 player.lvlxp=0
 player.gamescene="intro"
 player.introover=false
 player.shake=false
 player.row=1
 player.colum=1
 player.rowoffset=22
 story=0
 bonustime=flr(rnd(100)+100)
 bonusword=""
 bonusinactive=true
 bonuswordarray={}
 bonusletter=1
 bonusoffset=1
 bonushurry=true
 typingallowed=false
 mouserecent=0
 oldmx=0
 oldmy=0
 speed=10

 
 banimation={}
 
 player.autofire=0
 
 player.x=-12
 player.y=81
 player.isshooting=false
 player.score=0
 player.diclvl=1
 buttonpressed=0	
 animation={}
 row1x=12
 row2x=17
 row3x=24 
 currword="start"
 currwordoffset=60
 previousword=""
 typedword={}
 currwordarray={}
 create_array()
 currletter=1
 hero.sprite=3
 hero.x=-6
 hero.y=50
 hero.hp=50
 hero.maxhp=50
 hero.colorset={4,2,6,7,9,14,15}
 hero.color=hero.colorset[flr(rnd(6)+1)]
 enemy={}
 enemies={}
 finishedwords={}
-- dictionary={"s","d","r"}
 kword={"k","i","l","l","i","n","g"}
 kx=128/2-12-(7*6/2)
 ky=17
 kcol={5,4,3,4,5,6,7,}
 kkern=4
 hurry=true
 trivia=""
 get_trivia()

end

function screen_layout()
 
 if (player.introover) then 
  map(0,0)
  if (t%5==0) then 
  
   if (fire==1) then
    fire=2
   else 
    fire=1
   end
  
  end
  
  if (fire==1) then
   spr(72,48,28)
   spr(72,96,20)
  else
   spr(71,48,28)
   spr(71,96,20)
  end
  --more building on fire after bomb
  if (hasbombed) then
   if (fire==1) then
    spr(71,64,36)
    spr(72,16,36)
    spr(71,8,32)
    spr(71,120,32)
   else
    spr(72,64,36)
    spr(71,16,36)
    spr(72,8,32)
    spr(72,120,32)
   end  
  
  end
  
 else 
  map(0,9)
 end
 
 if (player.gamescene=="death") then
  map(0,9)
 end


 --current word
 rectfill(0,75,127,85,2)
 rect(0,75,127,85,5)
 --keyboard
 rectfill(0,85,127,127,1)
 rect(0,85,127,127,5)
 --keyboard uslesss lines
 rect(0,94,127,99,0) 
 rect(0,104,127,109,0)
 rect(0,114,127,119,0)

 rect(0,94,127,98,5) 
 rect(0,104,127,108,5)
 rect(0,114,127,118,5)
  
 --keyboard keys outline
 rect(10,91,110,102,0) 
 rect(15,101,105,112,0)
 rect(22,111,92,122,0)
 rectfill(10,91,110,101,6) 
 rectfill(15,101,105,111,6)
 rectfill(22,111,92,121,6)
 rect(10,91,110,101,5) 
 rect(15,101,105,111,5)
 rect(22,111,92,121,5)
 for i=1,9 do 
  line(10+(10*i),91,10+(10*i),101,5)
  line(15+(10*i),101,15+(10*i),111,5)
  if (i<7) do line(22+(10*i),111,22+(10*i),121,5) end
 end
 --boarder
-- rect(o,o,127,127,5) moved to d_e()
end

function draw_score()
  --score bar
 rectfill(0,0,127,15,1)
 rect(0,0,127,15,5)
 if (player.introover) then
  print("score:",39,6,0)
  print("score:",40,5,3)
  print(player.score, 64,6,0)
  print(player.score, 65,5,10)
 else 
  print("use buttons, mouse or", 15,3,0)
  print("use buttons, mouse or", 15,2,10)
   
  print("press 'k' to use keyboard", 15,10,0)
  print("press 'k' to use keyboard", 15,9,10)
 end
 
   --flashing for fire
  if (bonushurry) and (player.autofire>1) then
  -- flashing bonus
   print("rapid:"..player.autofire, 90,7,0)
   print("rapid:"..player.autofire, 91,6,10)

   print("rapid:"..player.autofire, 6,7,0)
   print("rapid:"..player.autofire, 7,6,10)
  end
end



function create_array()
 
 currwordarray={}
 
 for i=1,#currword do
  letter=sub(currword,i,i)
  add(currwordarray,letter)
 end
end

function start_new_word()
 currwordoffset=60
 
 diciionary={}
 dictionary=get_dic()
 
 --story if lvl is high enough
 if (player.diclvl>2) and (story<30) then
  currword=dictionary[story+1]
  story+=1
 else 
  repeat
   local v=flr(rnd(#dictionary)+1)
   currword=dictionary[v]
  until not (previousword==currword)
 end
 
 currwordarray={}
 for i=1,#currword do
  letter=sub(currword,i,i)
  add(currwordarray,letter)
 end
 currletter=1
 
end

function drawaction()
 pal(7,hero.color)
 spr(hero.sprite,hero.x,hero.y)
 pal(7,7) 
 
 --draw sprites in layers
 for i=30,54 do
  for e in all (enemies) do
   
    if (e.name=="skull") then
     --adjust z-order for height
     if (e.y+16==i) then 
      d_e(e)
     end
    else
     if (e.y==i) then 
      d_e(e)
     end    
    end 
    
  end
 end
 
end

function d_e(e)
 --used above
     
     if (e.isalive) then
      
      -- draw outline
      for xx=-1,1 do
       for yy=-1,1 do
        
        //use special color for elites
        for c=1,15 do
         if (e.elite==true) then 
          if (t%10==0) then
           elitec+=1 
           if (elitec >= 14) then
            elitec=8 
           end
          end
          pal(c,elitec) --elites have blue outline
         else
          pal(c,1)
         end
        end        
         
        
        spr(e.sprite,e.x+xx,e.y+yy,e.sizex,e.sizey)
       end
      end
      -- reset palette
      pal()
     end
     spr(e.sprite,e.x,e.y,e.sizex,e.sizey)
     
     if (e.showhpbar) and (e.isalive) then
      local epx=(e.hp/e.maxhp*10)
      rectfill(e.x-3,e.y-5,e.x+9,e.y-2,5)
      rect(e.x-2,e.y-4,e.x-2+epx,e.y-3,8)
     end
     
     --grey boarder
     rect(o,o,127,127,5)
     
end

function add_enemy()
 local l={}
 l.x=133
 l.y=42+flr(rnd(10))
 l.name="enemy"
 l.maxhp=10
 l.hp=10  
 l.sizex=2
 l.sizey=2
 l.attack=10
 l.sprite=32
 l.isalive=true
 l.speed=flr(rnd(3)+5)
 l.value=250
 l.isattacking=false
 l.cleanup=60
 l.walk2=32
 l.walk1=34
 l.dead=36
 l.tempdead=38
 
 if (flr(rnd(12))==1) then
  //elite mob
  l.elite=true  
  l.showhpbar=false
 else
  //elite mob
  l.elite=false  
  l.showhpbar=false
 end 
 
 add(enemies, l)
 
end

function add_cat()
 local l={}
 l.x=133
 l.y=42+flr(rnd(10))
 l.name="cat"
 l.maxhp=5
 l.hp=5
 l.sizex=2
 l.sizey=2
 l.attack=5
 l.sprite=40
 l.isalive=true
 l.speed=flr(rnd(3)+2)
 l.value=80
 l.isattacking=false
 l.cleanup=60
 l.walk2=40
 l.walk1=42
 l.dead=44
 l.tempdead=46


 
 if (flr(rnd(30))==1) then
  //elite mob
  l.elite=true  
  l.showhpbar=false
 else
  //elite mob
  l.elite=false  
  l.showhpbar=false
 end
 
 add(enemies, l)
end
 
function add_bug()
 local l={}
 l.x=133
 l.y=38+flr(rnd(5))
 l.name="bug"
 l.maxhp=100
 l.hp=100
 l.sizex=1
 l.sizey=2
 l.attack=2
 l.sprite=8
 l.isalive=true
 l.speed=3
 l.value=35
 l.isattacking=false
 l.cleanup=60
 l.walk2=8
 l.walk1=9
 l.dead=10
 l.tempdead=11

 if (flr(rnd(200))==1) then
  //elite mob
  l.elite=true  
  l.showhpbar=false
 else
  //elite mob
  l.elite=false  
  l.showhpbar=false
 end 
 
 add(enemies, l)
 
end

function add_rabbit()
 local l={}
 l.x=133
 l.y=38+flr(rnd(5))
 l.name="rabbit"
 l.maxhp=9
 l.hp=9
 l.sizex=2
 l.sizey=2
 l.attack=2
 l.sprite=96
 l.isalive=true
 l.speed=flr(rnd(10)+10)
 l.value=535
 l.isattacking=false
 l.cleanup=60
 l.walk2=98
 l.walk1=96
 l.dead=100
 l.tempdead=102

 if (flr(rnd(34))==1) then
  //elite mob
  l.elite=true  
  l.showhpbar=false
 else
  //elite mob
  l.elite=false  
  l.showhpbar=false
 end 
   
 add(enemies, l)
 
end

function add_skull()
 local l={}
 l.x=133
 l.y=23+flr(rnd(12))
 l.name="skull"
 l.maxhp=15
 l.hp=15
 l.sizex=2
 l.sizey=4
 l.attack=8
 l.sprite=176
 l.isalive=true
 l.speed=flr(rnd(5)+1)
 l.value=300
 l.isattacking=false
 l.cleanup=60
 l.walk2=128
 l.walk1=130
 l.dead=136
 l.tempdead=134

 if (flr(rnd(4))==1) then
  //elite mob
  l.elite=true  
  l.showhpbar=false
 else
  //elite mob
  l.elite=false  
  l.showhpbar=false
 end 
 
 add(enemies, l)
 
end



function move_enemies()

 local remove={}

 for e in all (enemies) do
  
  if (e.isalive) then
   
   if (e.isattacking) then 
    
    if (hero.hp>0) and (t%30==0) then
     --attack player
     hero.hp-=e.attack
     sfx(8)
     add_animation(hero)
    if (e.sprite==e.walk2) then 
     e.sprite=e.walk1
    else
     e.sprite=e.walk2
    end
    
     if (hero.hp<=0) then 
      hero.hp=0
      player.gamescene="death"
      buttonpressed=t+100 
     end

    else
     --player died
    end
    
   elseif (t%10==0) then
 
    --move enemy different speeds
    --skull
    if (e.name=="skull") and (t%30==0) then

     e.x-=e.speed
     if (e.sprite==e.walk2) then 
      e.sprite=e.walk1
     else
      e.sprite=e.walk2
     end
          
    end

    --basic zombie
    if (e.name=="enemy") and (t%20==0) then

     e.x-=e.speed
     if (e.sprite==e.walk2) then 
      e.sprite=e.walk1
     else
      e.sprite=e.walk2
     end

    end
    
    --bug
    if (e.name=="bug") and (t%1==0) then

     e.x-=e.speed   
     if (e.sprite==e.walk2) then 
      e.sprite=e.walk1
     else
      e.sprite=e.walk2
     end
     
    end
 
    --rabbit
    if (e.name=="rabbit") and (t%60==0) then
    
     e.x-=e.speed
     if (e.sprite==e.walk2) then 
      e.sprite=e.walk1
     else
      e.sprite=e.walk2
     end
          
    end  

    --cat
    if (e.name=="cat") and (t%10==0) then

     e.x-=e.speed
     if (e.sprite==e.walk2) then 
      e.sprite=e.walk1
     else
      e.sprite=e.walk2
     end
     
    end
        
    
    --set isattacking player
    if (e.x<=hero.x+10) then e.isattacking=true end
    
   end
   
  else

   test=e.cleanup
   --death sprite
   if (e.cleanup==5) or (e.cleanup==3) or (e.cleanup==1) then
    e.sprite=206
   else 
    e.sprite=e.dead
   end
   

   e.cleanup-=1
   print(e.cleanup,e.x, e.y-20,8)

   if (e.cleanup<1) then 
    add(remove, e)
   end
    
  end
 
 end

 for t in all (remove) do
  del(enemies, t)
 end 

end
-->8
function intro_update()
 t+=1
 intro_playerimput()

 --if (t%5==0) then
  move_enemies()
  if (player.introover) then
   bonustime-=1
  end
 --end
 

 
    --extra bugs while typing
 if (t%20==0) and (typingallowed) then
  local s=flr(rnd(6))
  if (s==0) then 
   local a=flr(rnd(5))
   if (a==0) then 
    add_cat()
   elseif (a==1) then
    add_bug()
   elseif (a==2) then
    add_enemy()
   elseif (a==3) then
    add_rabbit()
   else
    add_skull()
   end
  end
 end
  
 
 --add enemies 
 if (t%200==0) and (player.introover) then
  local r=flr(rnd(100))
   if ((player.diclvl*5)+20>r) then
   local a=flr(rnd(4))
   if (a==0) then 
    add_cat()
   elseif (a==1) then
    add_bug()
   elseif (a==2) then
    add_enemy()
   else
    add_skull()
   end
   end
 end
 if (player.diclvl>1) then  
  if (t%300==0) and (player.introover) then
 
   local a=flr(rnd(3))
   if (a==0) then 
    add_cat()
   elseif (a==1) then
    add_bug()
   else
    add_skull()
   end
  
  end
 end

end

function intro_draw()

 //draw keyboard keys
 cls()
 
 screen_layout()
 move_bullets()
 run_animation()
 
 if (player.row==1) then
  player.rowoffset=row1x
 elseif (player.row==2) then
  player.rowoffset=row2x
 else 
  player.rowoffset=row3x
 end
 
-- spr(1,player.x+player.rowoffset+(10*player.colum),player.y+(player.row*10))
 rectfill(player.x+player.rowoffset+(10*player.colum),player.y+(player.row*10),player.x+player.rowoffset+(10*player.colum)+10,player.y+(player.row*10)+10,3)
 rect(player.x+player.rowoffset+(10*player.colum),player.y+(player.row*10),player.x+player.rowoffset+(10*player.colum)+10,player.y+(player.row*10)+10,8)
 
 row1={"q","w","e","r","t","y","u","i","o","p"}
 row2={"a","s","d","f","g","h","j","k","l"}
 row3={"z","x","c","v","b","n","m"}
 shake=0
 
 --keyboard shake and draw
 shakeit()
 for i=1,10 do
  shakeit()
  print(row1[i],3+(i*10)+shake,95+shake2,0)
  print(row1[i],4+(i*10)+shake,94+shake2,7)
 end
 for i=1,9 do
  shakeit()
  print(row2[i],8+(i*10)+shake,105+shake2,0)
  print(row2[i],9+(i*10)+shake,104+shake2,7)
 end
 for i=1,7 do
  shakeit()
  print(row3[i],15+(i*10)+shake,115+shake2,0)
  print(row3[i],16+(i*10)+shake,114+shake2,7)
 end
 
 draw_health()
 --print(test,50,10,8) 
 
 runfinishedwords()
 --startgame
 start()
 if not (player.introover) then
  display_killing()
 end
 
 --bonus shit
 if (bonustime<0) and (bonusinactive) then
  bonusinactive=false
  do_bonus()
 end
 
 if not (bonusinactive) then 
  draw_bonus()
 end
 
 --bomb animation
 for b in all(banimation) do
  spr(b.spr,b.x,b.y)
 end
 
 draw_score()
 
 --draw mouse pointer
 draw_mouse()
 
 --typing mode notification
 if (typingallowed) then
  print("t.mode",95,115,11)
 end

end

function intro_playerimput()
 
 --wait on button press
 if (t>buttonpressed) then
	 player.shake=false
	
	 --press up and down
  if (btn(2)) then
   sfx(0)
   typingallowed=false
   buttonpressed=t+4
   --player.shake=true
   player.row-=1
   if (player.row<1) then player.row=1 end
  end
 
  if (btn(3)) then
   sfx(0)
   typingallowed=false
   buttonpressed=t+4
   --player.shake=true
   player.row+=1
   if (player.row>3) then player.row=3 end
  end
  
  --press left and right
  if (btn(0)) then
   sfx(0)
   typingallowed=false
   buttonpressed=t+4
   --player.shake=true
   player.colum-=1
   if (player.colum<1) then player.colum=1 end
  end
  
  if (btn(1)) then
   sfx(0)
   typingallowed=false
   buttonpressed=t+4
   --player.shake=true
   player.colum+=1
  end
  
  --agjust for different colum lenght
   
   if (player.row==1) then
    if (player.colum>10) then player.colum=10 end
   elseif (player.row==2) then
    if (player.colum>9) then player.colum=9 end 
   else
    if (player.colum>7) then player.colum=7 end 
   end
   
   --check if current letter is right
   if (btn(4)) and not (typingallowed) then 
    buttonpressed=t+4
    check_letter_correct()
   end
   
 end
 
end 
 
function shakeit()

 if (player.shake==true) then 
  shake=flr(rnd(2))
  shake2=flr(rnd(2))
 else 
  shake=0
  shake2=0
 end
 
end

function start()

 if not (player.introover) then
  print("killing of the", 34,18,0) 
  print("        of the", 35,17,7) 
--  print("by jerkstore", 42,35,9)\
  print("type start to begin", 26,68,0)
  print("type start to begin", 27,67,11)

 
  if (hurry) then
  -- flashing hurry
   print("hurry!", 104,68,0)
   print("hurry!", 105,67,10)

   print("hurry!", 1,68,0)
   print("hurry!", 2,67,10)
  end
  
  if (t%15==0) then
   if (hurry) then 
    hurry=false
   else
    hurry=true
   end
  end
 else 
  drawaction()
 end
 display_currword(currwordarray)
end

function display_currword(cw)
 local x=128/2-(#cw*6/2)
 local y=78
 local col=8
 local kern=4
 
 currwordoffset-=2.5
 if (currwordoffset<0) then
  currwordoffset=0
 end
 
 for i=1,#cw do
  if (currletter>i) then
   col=11
  else
   col=8
  end
  
  print(cw[i],(x-(currwordoffset*i))-1+(kern*i),y+1,0)  
  print(cw[i],(x-(currwordoffset*i))+(kern*i),y,col)
 
 end
 
end

function check_letter_correct()
 local gamel=currwordarray[currletter]
 local playerl=get_keyboard_letter()
 local bonusl=bonuswordarray[bonusletter]
 
 if (gamel==playerl) then 
 --correct
  sfx(1)
  --rapid fire if not finished word
  if (player.autofire>1) and not (currletter==#currword) then
   player.autofire-=1
   sfx(9)
   shoot()
   if (player.lvlxp>5) then
    player.lvlxp=0
    speed-=1
    player.diclvl+=1
   else
    player.lvlxp+=1
   end
  end
  
  
  if (player.introover) then player.score+=25 end
  currletter+=1
  if (currletter>#currword) then
   --finished word
   
   player.score+=10*currletter
   if (currword=="fergalicious") then
    sfx(3)
    player.score+=500
   else
    sfx(9)
   end
   local cwa={}
   cwa.x=128/2+7-(currletter*6/2)
   cwa.y=78
   cwa.decay=30
   cwa.word=currword
   add(finishedwords,cwa)
   sfx(9)
   shoot()
   if (player.introover) then
    
    
    --slowly (every 5 lvls) speed up game
    if (player.lvlxp>5) then
     player.lvlxp=0
     speed-=1
     player.diclvl+=1
    else
     player.lvlxp+=1
    end
    
    if (speed<1) then speed=1 end
   end
   player.introover=true
   previousword=currword
   start_new_word()
  end
  
 elseif not (bonusl==playerl) then
 --wrong
  player.shake=true
  player.score-=5
  if (player.score<0) then player.score=0 end
  sfx(2)
 end
 
  if (bonusl==playerl) then
   --bunus letter correct
   sfx(1)
   bonusletter+=1
  	if (bonusletter>#bonuswordarray) then
    --finished word
    player.score+=10*bonusletter
    bonusinactive=true
    bonustime=flr(rnd(300)+50)
    
    --apply bonus effect
    if (bonusword=="bomb") then
     add_bomb()
     sfx(11)
    elseif (bonusword=="auto") then
     sfx(7)
     player.autofire+=10
    elseif (bonusword=="heal") then
     sfx(13)
     hero.hp=hero.maxhp
    end
    
   
   end
   
  end
 
end

function get_keyboard_letter()

 --get the letter keyboard cursor is over
 local r1={"q","w","e","r","t","y","u","i","o","p"}
 local r2={"a","s","d","f","g","h","j","k","l"}
 local r3={"z","x","c","v","b","n","m"}
 local x
 if (player.row==1) then 
  x=r1[player.colum]
 elseif (player.row==2) then
  x=r2[player.colum]
 elseif (player.row==3) then
  x=r3[player.colum]
 end
 
 return x

end

function draw_health()

 --display hero health bar
 if (player.introover) and (hero.x==10) and (player.gamescene=="intro") then
 
  local hpx=(hero.hp/hero.maxhp*10)
  --print(hpx,2,2,8)
  rectfill(hero.x-3,hero.y-5,hero.x+9,hero.y-2,5) 
  if (hero.hp>0) then
   rect(hero.x-2,hero.y-4,hpx+8,hero.y-3,8)
  end
  
 end
 
 
 --move character into screen if needed   
   
 if (t%10==0) and (player.introover) then
  if (hero.x<10) then
   hero.x+=2
   --sfx(6)
   if (hero.sprite==3) then
    hero.sprite=2
   else
    hero.sprite=3
   end
  end
 end

end


function display_killing()
--rainbow title text

 
 for i=1,7 do

  print(kword[i],kx-1+(kkern*i),ky+1,0)  
  print(kword[i],kx+(kkern*i),ky,kcol[i])
  if (t%3==0) then
    kcol[i]+=1
    --if (kcol[i]>13) then kcol[i]=1 end 
  end
 end
 
end
-->8
function shoot()
 local bullet={}
 bullet.x=hero.x
 bullet.y=hero.y
 if (player.autofire>1) then
  bullet.speed=5
  bullet.sprite=19
  bullet.flash=10
  bullet.damage=5
 else
  bullet.speed=2
  bullet.sprite=16
  bullet.flash=4
  bullet.damage=3
 end
 
 add(bullets, bullet)
 
 
end

function move_bullets()
 run_bomb_animation()
 
 local remove={}
 for b in all (bullets) do
  b.x+=b.speed
  
  if (b.flash>0) then 
   hero.sprite=4
   spr(17,hero.x+8,hero.y)
  elseif (b.flash==0) then
   hero.sprite=3
  end
  b.flash-=1
  
  
  spr(b.sprite,b.x,b.y)
  --enemy collicion check
  
  for e in all (enemies) do
   --print(e.isalive,10,120,11) 
   if (e.x<b.x) and (e.isalive) then 
    --enemy hit with bullet
    if (e.elite) then
     --e.
     player.score+=10
     e.showhpbar=true
     e.hp-=b.damage	
    else
     e.hp=0
    end
    
    --kill enemy if 0 hp
    if (e.hp<=0) then
     e.isalive=false
     e.sprite=e.tempdead   
     player.score+=e.value
    end
    sfx(4)
     --extra blood
     add_animation(e)
     if (flr(rnd(4))==3) then add_animation(e) end
    add(remove,b)
    
   end
  end
 end
 
 for x in all (remove) do
  del(bullets, x)
 end
 
 --add enemy if none exist
    local y=0
    for u in all (enemies) do
     if (u.isalive) then
      y+=1
     end
    end
    if (y==0) then
     add_enemy()
    end
 
end
-->8
--animation

function run_animation()

 local removeani={}
 
 for a in all (animation) do
  if (t%2==0) then
   a.x1-=a.velx1
   a.y1-=a.vely1
   a.vely1-=1
   a.x2-=a.velx2
   a.y2-=a.vely2
   a.vely2-=1
   a.x3-=a.velx3
   a.y3-=a.vely3
   a.vely3-=1
   a.life-=1
  end 
 
  spr(18,a.x2,a.y1)
  spr(18,a.x2,a.y2)
  spr(18,a.x3,a.y3)
  
  if (a.life<1) then 
   add(removeani, a)
  end 
 end
 
 for r in all (removeani) do
  del(animation, r)
 end 
 
end

function add_animation(e)
  local k={}
  k.x1=e.x
  k.y1=e.y
  k.velx1=flr(rnd(7))
  k.vely1=flr(rnd(5))
  k.x2=e.x
  k.y2=e.y
  k.velx2=flr(rnd(7))
  k.vely2=flr(rnd(5))
  k.x3=e.x
  k.y3=e.y
  k.velx3=flr(rnd(7))
  k.vely3=flr(rnd(5))
  k.life=30
  add(animation, k)
  
end


function runfinishedwords()
  local remove={}
  
  for x in all (finishedwords) do 

   local col = flr(rnd(14))
   print(x.word,x.x-1,x.y+1,0)
   print(x.word,x.x,x.y,col)
   x.y-=1
   x.decay-=1
   
   if (x.decay<=0) then 
    add(remove, x)
   end
   
  end
  
  for r in all (remove) do
   del(finishedwords,r)
  end
  
end

function add_bomb()
 local bomb={}
 bomb.spr=78
 bomb.x=64
 bomb.y=-5
 bomb.type="bomb"
 add(banimation, bomb)
end

function run_bomb_animation()
 local remove={}
 
 
 for b in all(banimation) do
  if (b.type=="bomb") do
   b.y+=2
   --bomb exaust
   local ex={}
   ex.spr=74
   ex.x=b.x
   ex.y=b.y-8
   ex.type="fire"
   ex.life=10
   add(banimation, ex)
     
   if (b.y>=58) then 
   --bomb hits grownd
    hasbombed=true
    sfx(12)
    for x in all (enemies) do
     if (x.elite) then
      x.hp-=10
      player.score+=6
      if (x.hp <=0) then
       x.hp=0
       x.isalive=false
       x.sprite=x.tempdead
       player.score+=x.value
       add_animation(x)       
      end
     else
      x.isalive=false
      x.sprite=x.tempdead
      player.score+=x.value
      add_animation(x)
     end
     
     --add fire
     local bomb={}
     bomb.spr=74
     bomb.x=x.x
     bomb.y=x.y
     bomb.type="fire"
     bomb.life=60
     add(banimation, bomb)
     
     
     --lvl up for each enemy
     if (player.lvlxp>5) then
      player.lvlxp=0
      --speed-=1
      player.diclvl+=1
     else
      player.lvlxp+=1
     end
     
    end
    add(remove, b)
    
    --more random bomb fire
    for i=1,8 do
     
     local bomb={}
     bomb.spr=74
     bomb.x=flr(rnd(100)+20)
     bomb.y=flr(rnd(10)+50)
     bomb.type="fire"
     bomb.life=60
     add(banimation, bomb)
    end
   end 
  else
   if (b.type=="fire") then 
    b.y-=0.2
    b.life-=1
    if (b.life>40) then 
     b.spr=74
    elseif (b.life>30) then
     b.spr=75
    elseif (b.life>20) then
     b.spr=76
    elseif (b.life>10) then
     b.spr=79
    end
   if (b.life<1) then 
    add(remove,b)
   end
   end
  end
 end
 
 for r in all(remove) do
  del(banimation, r)
 end
 
end
-->8
--dictionarys

function get_dic()

 d1={"bat","thing","boil","scab","kill","imp","slimer","rat","lice","chains","scared","sick","awful","cruel","dark","dire","evil","foul","gory","grim","hellish","horrid","nasty","vile","wicked","uncanny","spooky"}
 d2={"chud","creep","ghoul","zombie","vampire","corpse","torture","illness","chilling","creepy","demonic","dreadful","fiendish","ghastly","ghoulish","haunting","heinous","loathsome","macabre","morbid","odious","rotten"}
 d3={"boil","murder","werewolf", "fergalicious","sacrificial","nightmare","shamble","horrible","unspeakable","uncanny","supernatural","sinister","repulsive","petrifying","ominous","mysterious","monstrosity","harrowing","gruesome","frightening","coronavirus","bloodcurdling"}
 --d4={"killing","of","the","dead","by","jerkstore","chapter","one","when","the","dead","started","rising","from","their","graves","robert","was","actually","pleased","because","he","didnt","feel","like","going","to","work","any","longer","anyhow"}
 d4={"welcome","to","killing","of","the","dead","by","tony","soft","chapter","one","as","the","cities","burned","and","the","dead","rose","not","just","the","human","corpses","became","a","threat","i","cant","remember","which","came","first","the","beetles","or","the","undead","rabbits","they","all","seem","to","come","at","the","same","time","now","the","skeletons","the","ghouls","some","of","them","are","mutants","resistant","to","gun","fire","as","i","scavenge","outside","my","last","stand","looking","for","ammo","i","sometimes","find","a","bomb","or","machine","gun","to","help","fend","of","the","horrors","of","this","nightmare","sorry","this","is","unfinished","for","now","thanks","for","playing"}
 local dic={}
 if (player.diclvl>2) then 
  if (story>29) then
   --use d2 and d3 after story mode
   local c = flr(rnd(2))
   if (c==1) then
    dic=d3
   else
    dic=d2
   end
  else
   dic=d4
  end 
 elseif (player.diclvl>1) then
  dic=d2
 else
  dic=d1
  --fix
 end
 
 return dic
end

function get_trivia()
 trand=flr(rnd(3))
 if (trand==1) then
  trivia="m.i.l.f. mon$y"
 elseif (trand==2) then
  trivia="you were 2000 and late"
 else
  trivia="where is the love?"
 end
 
 return trivia
end
-->8
--death

function death_update()
 t+=1
 if (btn(4)) and (t>buttonpressed) then
  --player.gamescene="intro"
  resetgame()
 end
end

function death_draw()

 --draw keyboard keys
 cls()

 
 if (player.row==1) then
  player.rowoffset=row1x
 elseif (player.row==2) then
  player.rowoffset=row2x
 else 
  player.rowoffset=row3x
 end
 
-- spr(1,player.x+player.rowoffset+(10*player.colum),player.y+(player.row*10))
 rectfill(player.x+player.rowoffset+(10*player.colum),player.y+(player.row*10),player.x+player.rowoffset+(10*player.colum)+10,player.y+(player.row*10)+10,3)
 rect(player.x+player.rowoffset+(10*player.colum),player.y+(player.row*10),player.x+player.rowoffset+(10*player.colum)+10,player.y+(player.row*10)+10,8)
 
 row1={"q","w","e","r","t","y","u","i","o","p"}
 row2={"a","s","d","f","g","h","j","k","l"}
 row3={"z","x","c","v","b","n","m"}
 shake=0
 
 --keyboard shake and draw
 shakeit()
 for i=1,10 do
  shakeit()
  print(row1[i],3+(i*10)+shake,95+shake2,0)
  print(row1[i],4+(i*10)+shake,94+shake2,7)
 end
 for i=1,9 do
  shakeit()
  print(row2[i],8+(i*10)+shake,105+shake2,0)
  print(row2[i],9+(i*10)+shake,104+shake2,7)
 end
 for i=1,7 do
  shakeit()
  print(row3[i],15+(i*10)+shake,115+shake2,0)
  print(row3[i],16+(i*10)+shake,114+shake2,7)
 end
 
 screen_layout()
 
 if (t>buttonpressed) then
  print("press z",50,78,11)
 end
 
 if (currword=="fergalicious") then 
  print(trivia,19,69,0)
  print(trivia,20,68,10)
 else
  local string="you were killed by the dead"
  print(string,4,69,0)
  print(string,5,68,10)
 
 end
 
 
 
end
-->8
--bonus

function do_bonus()
 sfx(10)
 local rd=flr(rnd(3))
 
 bonuswordoffset=1

 if (rd==0) then 
  bonusword="auto"
 elseif (rd==1) then
  if (hero.hp<hero.maxhp) then
   bonusword="heal"
  else
   bonusword="bomb"
  end
 else
  bonusword="bomb"  
 end
 
 bonuswordarray={}
 for i=1,#bonusword do
  letter=sub(bonusword,i,i)
  add(bonuswordarray,letter)
 end
 bonusletter=1

end

function draw_bonus()
 local x=128/2-(#bonuswordarray*6/2)
 local y=17
 local col=8
 local kern=4
 
 bonusoffset-=0.1
 if (bonusoffset<0) then bonusoffset=0 end
 
 
 for i=1,#bonuswordarray do
  if (bonusletter>i) then
   col=flr(rnd(2)+9)
  else
   col=8
  end
  
  print(bonuswordarray[i],(x-(bonusoffset*i))-1+(kern*i),y+1,0)
 -- print(bonuswordarray[i],x+1+(kern*i),y-1,0)  
  print(bonuswordarray[i],(x-(bonusoffset*i))+(kern*i),y,col)
 
 end
 
  if (bonushurry) then
  -- flashing bonus
   print("type bonus!", 84,18,0)
   print("type bonus!", 85,17,10)

   print("type bonus!", 4,18,0)
   print("type bonus!", 5,17,10)
  end
  if (t%15==0) then
   if (bonushurry) then 
    bonushurry=false
   else
    bonushurry=true
   end
  end
 

 
end
-->8
--mouse inputs

function draw_mouse()
 
 circol=5
 
 if (stat(34)==1) then
  cirsize=10
 else
  cirsize=2
 end
 
 
 if (stat(33)>75) then 
 
  if (oldmx==stat(32)) and (oldmy==stat(33)) then
  
  else
   printh(oldmx)
   printh(stat(32))
   mouserecent=t+10
   oldmx=stat(32)
   oldmy=stat(33)
  end 
  
  if (t>mouserecent) then 
   circol=5
  else
   circol=flr(rnd(13)+1)
  end
  
  
  --print(player.colum,stat(32),stat(33),10)
  circ(stat(32),stat(33),cirsize,circol)
  --in top row
  if (stat(33)>=91) and (stat(33)<=100) then
   
   circol=flr(rnd(15))
   if (stat(32)>=10) and (stat(32)<=10+10*10) then
    player.row=1
    player.colum=flr(stat(32)/10)
   end
  end
  
  --in middle row
  if (stat(33)>=101) and (stat(33)<=110) then
   if (stat(32)>=15) and (stat(32)<=15+10*9) then
    player.row=2
    player.colum=flr((stat(32)-6)/10)
    if (player.colum<1) then player.colum=1 end
   end
  end
  
  --in bottom row
  if (stat(33)>=111) and (stat(33)<=120) then
   if (stat(32)>=22) and (stat(32)<=22+10*7) then
    player.row=3
    player.colum=flr((stat(32)-13)/10)
    if (player.colum<1) then player.colum=1 end
   end  
  end    
 
 --mouseclick
 if (stat(34)==1) and (t>buttonpressed) then
  buttonpressed=t+10
  check_letter_correct()
 end
 
 end
 
 --keyboard input
 kr1={"q","w","e","r","t","y","u","i","o","p"}
 kr2={"a","s","d","f","g","h","j","k","l"}
 kr3={"z","x","c","v","b","n","m"}
 
 
 if (stat(30)) then
  local pressed=stat(31)
  --supress pause menu
   if (pressed=="p") and (typingallowed) then 
    poke(0x5f30,1)
   end

  --allow typing with k
  if not (typingallowed) and (pressed=="k") then
   typingallowed=true
  end
  
  if (typingallowed) then
    
   for k=1,#kr1 do
    if (pressed==kr1[k]) then 
     player.row=1
     player.colum=k
     buttonpressed=t+4
     check_letter_correct()
    end
   end
  
   for k=1,#kr2 do
    if (pressed==kr2[k]) then 
     player.row=2
     player.colum=k
     buttonpressed=t+4
     check_letter_correct()
    end
   end
  
   for k=1,#kr3 do
    if (pressed==kr3[k]) then 
     player.row=3
     player.colum=k
     buttonpressed=t+4
     check_letter_correct()
    end
   end    
  end
 end

end

__gfx__
00000000cccccccc0007700000077000000770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000c111111c0007700000077000000770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700c111111c0007000000070000000700880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000c111111c0077700000777000007777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000c111111c0077708000777080007700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700c111111c0007070800070708000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000c111111c0070700000707000007070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000cccccccc0700070000707000070007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000a0000000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000006a00a00008000000000000099000000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000
000000000a0000000000000000000000000000000000000000000000000000000000000000000000000000000828200000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000022200600222060000000000222220600000000000000000000000000000000
00000000000a00000008000000000000000000000000000000000000000000000222220602222206008280000e28280600000000000000000000000000000000
00000000000000000000000800000000000000000000000000000000000000008222226082222260028828060002226000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000e0e0000e0e000082e2e260000e000000000000000000000000000000000000
000000000000000000000bbbb0000000000000000000000000000000000000000000000000000000003000030000000000000000000000000030000300000000
00000bbbb0000000000bbbb1bb0b000b000000000000000000000bbbe00000000000000000000000003300330000000000000000000000000033003300000000
000bbbb1bb000000000b1bbb3b00b0b00000000000000000000b8bb1b800000000300003000000000333333b3000000000000000000000000338338830000000
000b1bbb3300b0b0000b33bb3b00bb000000000000000000000b1b883e00b08000330033000000b00338b8b33000030000000000000000000838b8b3300000b0
000bb33b3b00bb00000bb333300b0b000000000000000000000b83bb3b008b0003bb33b330000300033bebb3300000300000000000000000038b707330000b00
000bbb33300b0b000b00000bb0000b0000000000000000000008b833800b0b0003b8b8bb30000300000bbbb3000000b000000000000000000003000300000b00
0000000bb0000b0000b0b000bbbbbb0000000000000000000000000bb0000b00033bebb3300000b00007070300000b0000000000000000000000707b330000b0
00b0b000bbbbbb00000b000b0bb0000000000000000000000080b000e8bb8b00000353b30000003000000003000003000000000000000000000008b8b80000b0
000b000b0bb000000bbbb0bb0b00000000000888808000000008000e0bb0000000000333b3bb33300000088333bb33000030000300000000003b0333333333b0
00bbb0bb0b0000000000bbb00b000000000b8881bb08000800bbb0bb0b0000000000033b3333300000007873b33330000083003300000000000b3b8338b33300
0000bbb00b0000000000000006500000000b1b88588880800000b8b008000000000003b33333b0000000b33b333bb000033833883080b830000000b33338bb00
000000000650000000000000555000000088858888008b000000000005500000000003b33b33300000000333b33330000888b883380330b00000833300333330
000000005555000000000000505000000008b85880888b000000000085850000000003030030b00000000b3000b030000382eb2828b00003003bb000003000b0
000000005005500000000000505500000800088bb08808800000000050055000000030033030300000000b3000303000000b82830888b80300000000b330b300
0000000250005000000000025005200000808080888222000000000850005000000bb000b0b033000000b03b0b30b00080083008b038330b00000000b0033000
00000002200022000000000220020000888808828b80000000000002200022000000000000000000000000000000000008330833800000800000000000000000
44444444cccccccc666666666666666644444444000000005555555566666666666666660000000000a0000000a0000000080090005000000000000000000000
49444424cccccccc6556556661161166444444440000000044444444611611666116116600000000080809080805090850950008500000000005500000000000
44444444cccccccc65565566611611664444424400000000aaaaaaaa611611666116116600000000000080a000000a0000000000000085000557755000500500
44424944cccccccc666666666666666644244444066660000000000066666666666666660000000009a9a80005a0a80000a08080000050000057750000000000
44444444cccccccc666666666666666644444444000000000000000066686a66666a86660000000000a0a9a0000059a000000a00008000000007700000000000
42444444cccccccc6556556661161166444444940000000000000000611a88666116a866000000000a0808a90a00085900008059000000500007700000000050
44494424cccccccc65565566611611664944444400000000000000006116a8666116886600000000809009008090090080900000005000000008800005000000
44444444cccccccc6666666666666666444444440000000000000000666666666666666600000000000a0000000a0000000a0500000000000000000000000000
44444444444444444444444444444444000000006666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
44444444444444244444444444444444000000006aa611666aa61166000000000000000000000000000000000000000000000000000000000000000000000000
44444444444444444444444444444494000000006aa611666aa61166000000000000000000000000000000000000000000000000000000000000000000000000
44444444444444444444444444444444555555556666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
44444444449444444444444444444444555555556666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
4444444444444444444442444444444400000000611611666aa6aa66000000000000000000000000000000000000000000000000000000000000000000000000
4444444444444444444444444444444400000000611611666aa6aa66000000000000000000000000000000000000000000000000000000000000000000000000
44444444444444444444444444444444555555556666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000007777700000000000000000000080000077700070000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000077770000000000000000000000000700770770000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000077000777700000000000000000070800700077000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000770007777700000000000000000000008770007008000000000000000000000000000000000000000000000000000000000000000000
00000000000000000007700777000000000000000000000000708870007000070000000000000000000000000000000000000000000000000000000000000000
00000000000000000077777700000000000000000000000000000887000000770000000000000000000000000000000000000000000000000000000000000000
00070000000000000778787777700000000000000000000008788887877000700000000000000000000000000000000000000000000000000000000000000000
00700077000006600777777777777000000000000000000088588857787777700000000000000000000000000000000000000000000000000000000000000000
00707770000066660007577077777000000000000000000000085700888770000000000000000000000000000000000000000000000000000000000000000000
00707000077776668880887707777700000077870080866000008008877777000000000000000000000000000000000000000000000000000000000000000000
00707007777777700088887707777770077070077088868607000077078777700000000000000000000000000000000000000000000000000000000000000000
00777077777777700700777000777760708880887788768600000780007877600000000000000000000000000000000000000000000000000000000000000000
07878777777777700777700000777666788888778887777080077800008776660000000000000000000000000000000000000000000000000000000000000000
07777777777770000000000007777666877787887777877800008000078786860000000000000000000000000000000000000000000000000000000000000000
00757007700077000000007777777660707870078080770800000077777776600000000000000000000000000000000000000000000000000000000000000000
00000077000777000000007770777700080000000000800000088077707778000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000777777000000000077777700000000000000000000000000777777000000000000000000000000000000000000000000000000000000000000000000000
00007777777700000000777777770000000000000000000000087777877700000000000000000000000000000000000000000000000000000000000000000000
00077777777770000003777773777000000000000000000000088878757770000000000000000000000000000000000000000000000000000000000000000000
00073777377777000003377733777700000000000000000000055788557877000000000000000000000000000000000000000000000000000000000000000000
00073373377777000007337337777700000000000000000000075575577777000000000000000000000000000000000000000000000000000000000000000000
00777777777777000077775777777700000000000000000000777857787777000000000000000000000000000000000000000000000000000000000000000000
00777757777777000077755577777700000857577558000000787555777777000000000000000000000000000000000000000000000000000000000000000000
00777555775777000077777777577700000555778775500000778887775777000000000000000000000000000000000000000000000000000000000000000000
00077777777570000007666666757000000785877755850000076686667570000000000000000000000000000000000000000000000000000000000000000000
00007777767700000000636363670000000735753555550000006565656700000000000000000000000000000000000000000000000000000000000000000000
00006363636700000000033333670000000735555755770000000555856700000000000000000000000000000000000000000000000000000000000000000000
00000636367700000000063636770000007758577558770000000656567700000000000000000000000000000000000000000000000000000000000000000000
00007777777000000000766667700000007888577758870000007666677000000000000000000000000000000000000000000000000000000000000000000000
00007777770000000000777777000000000087888377850000007777770000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000080008000000008000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000770070000000000000000000000000000000000000000000880000000000000000000000000000000000000000000000000000000000000000
00700000000070770700000000007077000000000000000000700000000070770088737000000000000000000000000000000000000000000000000000000000
07077777077770070777777707777077000000000000000007077777077770080337337700000000000000000000000000000000000000000000000000000000
07700007700070770700000770007007000000000000000008700007800070870777888770000000000000000000000000000000000000000000000000000000
07077777777700700707777777770077000000000000000007078777778700700775777770580000000000000000000000000000000000000000000000000000
07000007700000700700000770000070000000000000000007000008700000700755887887755000000000000000000000000000000000000000000000000000
07007777777700700700777777770070000000000000000008007778777800700877877758558500000000000000000000000000000000000000000000000000
07000007700000770000000770000070000000000000000007000008700000770878876777555500000000000000000000000000000000000000000000000000
07000777777700000700077777770077000000000000000007000777877700000836363673557770000000000000000000000000000000000000000000000000
00000700700707777770070070070000000000000000000000000700700707877063636775587700000000000000000000000000000000000000000000000000
07000777777700770770077777770777000000000000000007000778888700880078885778588700000000000000000000000000000000000000000000000000
77700077777007077077007777700077000000000000000077800077787007070000878877887800000000000000000000000000000000000000000000000000
07700070000000000000000000700707000000000000000008700000007000000800880807707088000000000000000000000000000000000000000000000000
70770070007000000000007000700000000000000000000070780070007000000077077870708077000000000000000000000000000000000000000000000000
00007770007000000000007007700000000000000000000000000080007000000788000887008887000000000000000000000000000000000000000000000000
00000000077000000000777000000000000000000000000000007770077000000080777778070070000000000000000000000000000000000000000000000000
__label__
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
51111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111115
51111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111115
51111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111115
51111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111115
51111111111111111111111111111111111111111331133113313331333111111aaa111111111111111111111111111111111111111111111111111111111115
51111111111111111111111111111111111111113011301130303030301113110a0a111111111111111111111111111111111111111111111111111111111115
51111111111111111111111111111111111111103330311030303310331101110a0a111111111111111111111111111111111111111111111111111111111115
51111111111111111111111111111111111111100030311030303130311113110a0a111111111111111111111111111111111111111111111111111111111115
51111111111111111111111111111111111111113310133033103030333101110aaa111111111111111111111111111111111111111111111111111111111115
51111111111111111111111111111111111111100111001001101010001111110001111111111111111111111111111111111111111111111111111111111115
51111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111115
51111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111115
51111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111115
51111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111115
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
54444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444445
54444424494444244444442449444424444242411140442144422243394444244444772777444427774747277744442449444424444444444944442444444425
54444444444444444444444444444444440202001400440144002403434404444447070704444400740707070444444444444444444444444444444444444445
54444444444249444444444444424944440224401400490144402403030449444407070774424940740777077444444444424944444444444442494444444445
54944444444444444494444444444444440242401400440144402403030444444407070744444440740707074494444444444444444444444444444444944445
54444444424444444444444442444444440202411100000111422203030444444407740742444440720707077744444442444444444442444244444444444445
54444444444944244444444444494424440404000400040004000404040004244400440444494420440904000444444444494424444444444449442444444445
54444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444445
54444444666666666666666644444444444444446666666666666666444444444444444466666666444444444444444466666666666666664444444444444445
59444424655655666aa61166444444444444444465565566611611664444442444444424611611664944442444444424655655666aa611664944442444444425
54444444655655666aa61166444444444444444465565566611611664444444444444444611611664444444444444444655655666aa611664444444444444445
54424944666666666666666644444444444444446666666666666666444444444444444466666666444249444444444466666666666666664442494444444445
54444444666666666666666644444444444444446666666666666666449444444494444466666666444444444494444466666666666666664444444444944445
52444444655655666116116644444244444442446556556661161166444444444444444461161166424444444444444465565566611611664244444444444445
54494424655655666116116644444444444444446556556661161166444444444444444461161166444944244444444465565566611611664449442444444445
54444444666666666666666644444444444444446666666666666666444444444444444466666666444444444444444466666666666666664444444444444445
54444444666666664444444466666666444444446666666644444444444444446666666644444444666666664444444466666666444444446666666644444445
59444424611611664444442465565566494444246aa611664444442449444424611611664444444461161166494444246aa61166444444446116116649444425
54444444611611664444444465565566444444446aa611664444444444444444611611664444444461161166444444446aa61166444442446116116644444445
54424944666666664444444466666666444249446666666644444444444249446666666644444444666666664442494466666666442444446666666644424945
54444444666666664494444466666666444444446666666644944444444444446666666644444444666666664444444466666666444444446666666644444445
52444444611611664444444465565566424444446116116644444444424444446116116644444244611611664244444461161166444444946116116642444445
54494424611611664444444465565566444944246116116644444444444944246116116644444444611611664449442461161166494444446116116644494425
54444444666666664444444466666666444444446666666644444444444444446666666644444444666666664444444466666666444444446666666644444445
54444444666666664444444466666666444444446666666666666666444444446666666666666666666666664444444466666666444444446666666644444445
544444246aa61166444444246aa6116644444444655655666aa61166444444446aa611666556556665565566444444246aa61166494444246aa6116644444425
544444446aa61166444444446aa6116644444494655655666aa61166444444446aa611666556556665565566444444446aa61166444444446aa6116644444445
54444444666666664444444466666666444444446666666666666666444444446666666666666666666666664444444466666666444249446666666644444445
54944444666666664494444466666666444444446666666666666666444444446666666666666666666666664494444466666666444444446666666644944445
5444444461161166444444446aa6aa66444444446556556661161166444442446116116665565566655655664444444461161166424444446aa6aa6644444445
5444444461161166444444446aa6aa66444444446556556661161166444444446116116665565566655655664444444461161166444944246aa6aa6644444445
54444444666666664444444466666666444444446666666666666666444444446666666666666666666666664444444466666666444444446666666644444445
54444444666666664444444466666666444444446666666644444444444444446666666644444444666666664444444466666666444444446666666644444445
544444446116116644444444611611664944442461161166494444244444444461161166494444246aa611664444442461161166494444246556556644444445
544444446116116644444444611611664444444461161166444444444444424461161166444444446aa611664444444461161166444444446556556644444445
54444444666666664444444466666666444249446666666644424944442444446666666644424944666666664444444466666666444249446666666644444445
54444444666666664444444466666666444444446666666644444444444444446666666644444444666666664494444466666666444444446666666644444445
54444244611611664444424461161166424444446116116642444444444444946116116642444444611611664444444461161166424444446556556644444245
54444444611611664444444461161166444944246116116644494424494444446116116644494424611611664444444461161166444944246556556644444445
54444444666666664444444466666666444444446666666644444444444444446666666644444444666666664444444466666666444444446666666644444445
54444444666666666666666644444444444444446666666666666666444444446666666644444444666666664444444466666666666666664444444444444445
594444246aa611666116116649444424444444446aa6116665565566444444446aa6116644444444611611664944442465565566611611664944442449444425
544444446aa611666116116644444444444444446aa6116665565566444444446aa6116644444444611611664444444465565566611611664444444444444445
54424944666666666666666644424944444444446666666666666666444444446666666644444444666666664442494466666666666666664442494444424945
54444444666666666666666644444444444444446666666666666666444444446666666644444444666666664444444466666666666666664444444444444445
52444444611611666116116642444444444442446116116665565566444442446116116644444244611611664244444465565566611611664244444442444445
54494424611611666116116644494424444444446116116665565566444444446116116644444444611611664449442465565566611611664449442444494425
54444444666666666666666644444444444444446666666666666666444444446666666644444444666666664444444466666666666666664444444444444445
54444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444445
54444444494444244444444444444444494444244444442444444444494444244444442444444444444444444444444444444444444444444444444444444445
54444444444444444444449444444444444444444444444444444244444444444444444444444494444444944444424444444244444442444444449444444445
54a4a4a4a4aaa9aaa4a4a44a444bbb4b4b4bbb4bbb444444bb2bbb4bbb4bbb4bbb44444bbb44bb44444bbb4bbb24bb4bbb2bb4444a2a4a4a4aaa4aaa4a4a44a5
50a0a0a0a0a0a0a0a0a0a40a4400b40b0b0b0b0b0494444b0400b40b0b0b0b00b4944400b44b0b44440b0b0b044b0400b40b4b440a0a0a0a0a0a0a0a0a0a40a5
50aaa0a0a0aa40aa40aaa40a4440b20bbb0bbb0bb444440bbb40b40bbb0bb440b4444440b40b0b44440bb40bb40b4490b40b0b940aaa0a0a0aa40aa40aaa40a5
50a0a0a0a0a9a0a4a000a4044440b4000b0b040b444444000b40b40b0b0b4b20b4444440b40b0b44440b4b0b490b4b40b90b0b440a0a0a0a0a4a0a4a000a4045
50a0a04aa0a0a0a0a4aaa44a4440b44bbb0b440bbb44444bb440b40b0b0b0b40b4444440b40bb444440bbb0bbb0bbb4bbb0b0b440a0a04aa0a0a0a0a4aaa44a5
50404400404040404000440444404400040444000444440044404404040404404444444044004444440004000400040004040444040440040404040400044045
54444444444444244444444444444424444444444444444444444444444444444444444444444444444444444444442444444444444444444444444444444445
54444494444444444444424444444444444442444444449444444244444444944444424444444494444442444444444444444494444442444444424444444495
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
52222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222225
52222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222225
52222222222222222222222222222222222222222222222222222288288828882888288822222222222222222222222222222222222222222222222222222225
52222222222222222222222222222222222222222222222222222802008208080808008222222222222222222222222222222222222222222222222222222225
52222222222222222222222222222222222222222222222222220888208208880882208222222222222222222222222222222222222222222222222222222225
52222222222222222222222222222222222222222222222222220008208208080828208222222222222222222222222222222222222222222222222222222225
52222222222222222222222222222222222222222222222222222882208208080808208222222222222222222222222222222222222222222222222222222225
52222222222222222222222222222222222222222222222222220022202202020202202222222222222222222222222222222222222222222222222222222225
52222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222225
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
51111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111115
51111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111115
51111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111115
51111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111115
51111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111115
51111111118888888888855555555555555555555555555555555555555555555555555555555555555555555555555555555555555555511111111111111115
51111111118333333333866666666656666666665666666666566666666656666666665666666666566666666656666666665666666666511111111111111115
51111111118333333333866666666656666666665666666666566666666656666666665666666666566666666656666666665666666666511111111111111115
55555555558333373333866676766656667776665666777666566677766656667676665666767666566677766656666776665666777666555555555555555555
51111111118333737333866070766656607066665660707666566007666656607076665660707666566007666656667076665660707666511111111111111115
51111111118330707333866070766656607766665660776666566607666656607776665660707666566607666656607076665660777666511111111111111115
51111111118330773333866077766656607666665660767666566607666656600076665660707666566607666656607076665660706666511111111111111115
55555555558330077333866077766656607776665660707666566607666656667776665660677666566677766656607766665660766666555555555555555555
50000000008333003333866000666656600066665660606666566606666656600066665666006666566000666656600666665660666666500000000000000005
51111111118333333333866666666656666666665666666666566666666656666666665666666666566666666656666666665666666666511111111111111115
51111111118888888888855555555555555555555555555555555555555555555555555555555555555555555555555555555555555555511111111111111115
51111111110000056666666665666666666566666666656666666665666666666566666666656666666665666666666566666666650000011111111111111115
51111111111111156666666665666666666566666666656666666665666666666566666666656666666665666666666566666666651111111111111111111115
55555555555555556667776665666677666566677666656667776665666677666566676766656667776665666767666566676666655555555555555555555555
51111111111111156607076665666706666566076766656607066665666706666566070766656600766665660707666566076666651111111111111111111115
51111111111111156607776665660777666566070766656607766665660766666566077766656660766665660776666566076666651111111111111111111115
51111111111111156607076665660007666566070766656607666665660767666566070766656660766665660767666566076666651111111111111111111115
55555555555555556607076665666776666566077766656607666665660777666566070766656667766665660707666566077766655555555555555555555555
50000000000000056606066665660066666566000666656606666665660006666566060666656600666665660606666566000666650000000000000000000005
51111111111111156666666665666666666566666666656666666665666666666566666666656666666665666666666566666666651111111111111111111115
51111111111111155555555555555555555555555555555555555555555555555555555555555555555555555555555555555555551111111111111111111115
51111111111111100000005666666666566666666656666666665666666666566666666656666666665666666666500000000000001111111111111111111115
51111111111111111111115666666666566666666656666666665666666666566666666656666666665666666666511111111111111111111111111111111115
55555555555555555555555666777666566676766656666776665666767666566677766656667766665666777666555555555555555555555555555555555555
51111111111111111111115660007666566070766656667066665660707666566070766656607676665660777666511111111111111111111111111111111115
51111111111111111111115666676666566067666656607666665660707666566077666656607076665660707666511111111111111111111111111111111115
51111111111111111111115666766666566676766656607666665660777666566076766656607076665660707666511111111111111111111111111111111115
55555555555555555555555660777666566070766656606776665660076666566077766656607076665660707666555555555555555555555555555555555555
50000000000000000000005660006666566060666656660066665666066666566000666656606066665660606666500000000000000000000000000000000005
51111111111111111111115666666666566666666656666666665666666666566666666656666666665666666666511111111111111111111111111111111115
51111111111111111111115555555555555555555555555555555555555555555555555555555555555555555555511111111111111111111111111111111115
51111111111111111111110000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111115
51111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111115
51111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111115
51111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111115
51111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111115
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555

__map__
4141414141414141414141414141414100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4141414141414141414141414141414100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4141414141414141414141414141414100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4341414143414241434141414241434100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4342434143424241434141434241434300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4342434243424243434142434241434300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4646464646464646464646464646464600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4545454545454545454545454545454500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5454545454545454545454545454545400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5051405140535151405140404052405300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5352535144525152515151525152514000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5140514052405340514040514052405100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4042555252424351514340514255405100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4043514240555140435243405544434000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5155515653425552554242515540565100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5243524340434044434055514340425200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4055434052554252555243404243404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5240535240514440515353444444535200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5351445144534453445344515344445300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000e0501e0501d0500e05004050000000000012400104000c4000a400094000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a000010120161201c12022120231202812029120061000710008100091000a1000b1001010013100161001b1001d1002210024100271002d1003510039100000003c100000003c1003c100000000000000000
001000002c1501e15018150101500b15001150001500c100031000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000300000a2501225015250182501a2501d2502025023250242502125019250122500e250112501225016250192501f250232502625025250202501b250182501525012250102500c2500d25011250152501b250
000900000d65006650026500065000600006000560000600066000560005600046000460003600036000260001600006000000000000000000000000000000000000000000000000000000000000000000000000
000800001615017150061500615024200182001c20004200142000d20007200022000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000900000965009600096000a6000a600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0010000033750287500a7502175004750000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001400001945007450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000b00003f150000001830000000123002430000000333002530000000000003c3000000033300000000000000000000000000000000393000000000000000000000000000000000000000000000000000000000
00090000061501a15000000131500000024150000001c150000002f15000000000002a150000003b1500000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000d00003d1503875034750307502c75027750237501e7501975014750107500a75004750007501e6002c600206001660021600226001360027600296000b600276002a60016600256000d6001b6002860025600
000500001f6502c650376503965039650396503965038650376503565033650316502f6502d6502b6502665022650216501b6501865015650126500f6500c6500965007650056500365001650006500060000600
000c00000e250002000f25012250002000d250172501e25000200002000f250202502c25000200002000020000200002000020000200002000020000200002000020000200002000020000200002000020000200
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0010001f195501950000000000000000000000000000000016550165000b50021500215500c5000c5500c500195500b500025001b5001850017500175001750017500175001750000000000002a5000000000000
001000200344000040166400004003440000401664003440000400344016640000400344000040166400344000040034401664000040034400004016640000400344000040166400004000040000401664000040
000800000f57005570005700a5700057000500045000e55000550005000555000550005000e560005200f5000f50005500005700a5700057000500045500e5500f50005500005000a5700057000550045000e550
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00100020153501532000000000000a3500a3200a30000000000000000000000000000935009320173501732000000000000a3500a3200a3000a30000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000033700327003f7003c70037700337000b7002a700257003b7503b72031750317202a7502a7201e7501e7201375013720
__music__
01 15525344
01 15164344
01 15125644
02 15121644

