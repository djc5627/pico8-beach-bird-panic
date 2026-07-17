function hit(x1,y1,w1,h1,x2,y2,w2,h2,goalx,goaly)
  -- minkowsky difference between 2 aabbs, which is another aabb
  local x,y,w,h=x2-x1-w1,y2-y1-h1,w1+w2,h1+h2
  local dx,dy=goalx-x1,goaly-y1
  -- if diff contains point 0,0, there's intersection between first and second aabb
  if x<0 and x+w>0 and y<0 and y+h>0 then return true end
  -- no intersection, or intersection with movement - liang-barsky line-clipping with normals
  local t1,t2=-32768,32767
  for side=1,4 do
    local p,q
    if     side==1 then p,q=-dx,-x
    elseif side==2 then p,q=dx,x+w
    elseif side==3 then p,q=-dy,-y
    else                p,q=dy,y+h
    end
    if p==0 then
      if q<=0 then return false end
    else
      local r=q/p
      if p<0 then
        if r>t2 then return false elseif r>t1 then t1=r end
      else
        if r<t1 then return false elseif r<t2 then t2=r end
      end
    end
  end
  return 0<=t1 and t1<=1
end