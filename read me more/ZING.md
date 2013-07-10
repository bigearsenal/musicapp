
### Analysis
Given the following link:

<http://mp3.zing.vn/xml/load-song/MjAxMCUyRjExJTJGMDElMkZmJTJGOSUyRmY5ZjAxZGVmZDgwZmY0ZDIzOTNmNmJkMDc0MjZkNmQ4Lm1wMyU3QzI=>

Change any character in the uri. The server will generate a specific url which contains a relative path of a file and a pair of timestamp and a hash string. The hash string will be made of the timestamp, the path and maybe a salt (a secret key). As I will explain later, the hash string does not depend on the given link. Therefore, we will exlude it in our analysis. The task is supposed to find the relationship between the file path and the encoded string in the link. Let

	sA = "MjAxMCUyRjExJTJGMDElMkZmJTJGOSUyRmY5ZjAxZGVmZDgwZmY0ZDIzOTNmNmJkMDc0MjZkNmQ4Lm1wMyU3QzI"
	sB = "2010/11/01/f/9/f9f01defd80ff4d2393f6bd07426d6d8.mp3"

be our example.


We notice that the `=` sign in the encoded string is special. Let’s assume it does not refect to our finding general pattern and will be excluded. The encoded one hereby contains only characters `a-z`,`A-Z`,`0-9`. Let `base62="0..9A..Za..z"` be a string of those characters above. The general rule of this technique of finding the result is substitution term. A group A will be replaced by a group B. Our mission is to find out the mapping between A and B. Let the encoded string (sA) be fixed and represent the original string. So we will replace every position in the original with a character from base62. We have to filter the resulted string (sB) after being replaced which contains invalid characters such as char code is out of ascii. Let us assume for the simplicity’sake the Group A and B contain only one char. Therefore we will take a note to the change in a given position of the encoded string and the calculated one. We got the following finding:
	
	TABLE 1
	0:(M,2)=>0:(L,.)
	0:(M,2)=>0:(N,6)
	0:(M,2)=>0:(Z,f)
	0:(M,2)=>0:(Y,b)
	1:(j,2)=>0:(D,0)
	1:(j,2)=>0:(T,1)
	1:(j,0)=>1:(n,p)
	1:(j,2)=>0:(z,3)
	2:(A,0)=>1:(E,1)
	2:(A,0)=>1:(I,2)
	2:(A,0)=>1:(M,3)
	2:(A,0)=>1:(Q,4)
	2:(A,0)=>1:(U,5)
	2:(A,0)=>1:(Y,6)
	2:(A,0)=>1:(c,7)
	2:(A,0)=>1:(g,8)
	2:(A,0)=>1:(k,9)
	3:(x,1)=>2:(1,5)
	3:(x,1)=>2:(2,6)
	3:(x,1)=>2:(0,4)
	3:(x,1)=>2:(3,7)
	3:(x,1)=>2:(4,8)
	3:(x,1)=>2:(5,9)
	3:(x,1)=>2:(u,.)
	3:(x,1)=>2:(w,0)
	3:(x,1)=>2:(y,2)
	3:(x,1)=>2:(v,/)
	3:(x,1)=>2:(z,3)
	..................
	

The pattern of `0:(M,2)=>0:(L,.)` interpreted as the char M at the first index of `sA` whose encoded char is `2` in the calculated one. If we replace `M` by `L` then the first position of `sB` will be replaced by `.` (dot). The first position of sB is dependent on the first and the second char of sA. The second position of sB is dependent on the second and the third char of sA. The third position of sB seems to be up to only the fourth position of sA. The same thing applies to the next 4 characters of sA. There will be some exeptions, but let these one represent something else and will be ignored. We put our focus on the founded pattern. Let

	groupA be a group containing 4 characters
	groupB be a group containing 3 charactes.

#### Part 1: Finding the relationship of the first 2 characters in groupA and groupB

The first 2 characters of groupB depend on first 3 characters of groupA. Moreover the last one of groupB is only dependent on the last one of groupA. In our specific case, the groupA is illustrated by  `MjAx` and the groupB is illustrated by `201`. Now let changing the first 2 character of groupA in sA and each is from base62 string and let the third char fixed, in this case it is char `A`. We also eliminate invalid characters from the result. Let's choose random chunk of the calculated hash table and look at the result when `groupA[0]` is `K`. 
	
	TABLE 2
	(IC)=>(  )---(73,67)=>(32,32)
	.............................
	(K0)=>( @)---(75,48)=>(32,64)
	(K1)=>( P)---(75,49)=>(32,80)
	(K2)=>( `)---(75,50)=>(32,96)
	(K3)=>( p)---(75,51)=>(32,112)
	(KC)=>(( )---(75,67)=>(40,32)
	(KD)=>((0)---(75,68)=>(40,48)
	(KE)=>((@)---(75,69)=>(40,64)
	(KF)=>((P)---(75,70)=>(40,80)
	(KG)=>((`)---(75,71)=>(40,96)
	(KH)=>((p)---(75,72)=>(40,112)
	(KS)=>() )---(75,83)=>(41,32)
	(KT)=>()0)---(75,84)=>(41,48)
	(KU)=>()@)---(75,85)=>(41,64)
	(KX)=>()p)---(75,88)=>(41,112)
	(KV)=>()P)---(75,86)=>(41,80)
	(KW)=>()`)---(75,87)=>(41,96)
	(Ki)=>(* )---(75,105)=>(42,32)
	(Kk)=>(*@)---(75,107)=>(42,64)
	(Kj)=>(*0)---(75,106)=>(42,48)
	(Kl)=>(*P)---(75,108)=>(42,80)
	(Kn)=>(*p)---(75,110)=>(42,112)
	(Km)=>(*`)---(75,109)=>(42,96)
	(Kz)=>( 0)---(75,122)=>(32,48)
	(Ky)=>(  )---(75,121)=>(32,32)
	.............................
	(Qk)=>(B@)---(81,107)=>(66,64)
	(Ql)=>(BP)---(81,108)=>(66,80)
	..............................
	(fy)=>( )---(102,121)=>(127,32)
	(fz)=>(0)---(102,122)=>(127,48)

The line `(K0)=>( @)---(75,48)=>(32,64)` means `K0` of the groupA is equivalent to `[space]@` of the groupB. And the numbers in `(75,48)=>(32,64)` are char codes of `K0` and `[space]@`. The char code of the first character in the groupB increased. Let change the hash table ordered by char code of `groupB[1]` and `groupB[0]` ascendently. 

	TABLE 3
	(Ky)=>(  )---(75,121)=>(32,32)
	(Kz)=>( 0)---(75,122)=>(32,48)
	(K0)=>( @)---(75,48)=>(32,64)
	(K1)=>( P)---(75,49)=>(32,80)
	(K2)=>( `)---(75,50)=>(32,96)
	(K3)=>( p)---(75,51)=>(32,112)

	(KC)=>(( )---(75,67)=>(40,32)
	(KD)=>((0)---(75,68)=>(40,48)
	(KE)=>((@)---(75,69)=>(40,64)
	(KF)=>((P)---(75,70)=>(40,80)
	(KG)=>((`)---(75,71)=>(40,96)
	(KH)=>((p)---(75,72)=>(40,112)

	(KS)=>() )---(75,83)=>(41,32)
	(KT)=>()0)---(75,84)=>(41,48)
	(KU)=>()@)---(75,85)=>(41,64)
	(KV)=>()P)---(75,86)=>(41,80)
	(KW)=>()`)---(75,87)=>(41,96)
	(KX)=>()p)---(75,88)=>(41,112)

	(Ki)=>(* )---(75,105)=>(42,32)
	(Kj)=>(*0)---(75,106)=>(42,48)
	(Kk)=>(*@)---(75,107)=>(42,64)
	(Kl)=>(*P)---(75,108)=>(42,80)
	(Km)=>(*`)---(75,109)=>(42,96)
	(Kn)=>(*p)---(75,110)=>(42,112)
	
Clearly, we can observe that the second char of groupB is increased whose circle is 6. After that the first char of groupB is also incresed as well. The char code of the first varies from 32 to 127 while the second is repeated in 32,48,64,80.96,112 whose difference is 16 units. Therefore the groupA can be denoted by a number (base 10) through a transformation of groupA. Now let's find out which nummeric system the groupA belongs to. Because we have order the hash table by the increse of 2 char codes in groupB, the smallest value of `groupA[0,1]` is equivalent to the line: `(IC)=>(  )---(73,67)=>(32,32)`. Therefore `I` the smallest value of groupA[0] and `C` is the smallest one of groupA[1]. We easily find out  the first and the second char of the groupA varies in 2 groups of 24 different characters. We see the second char of the groupB is repeated with some characters. Finally we have 2 different base 24's. 
	
	groupA[0] in "IJKLMNOPQRSTUVWXYZabcdef" => base24A
	groupA[1] in "CDEFGHSTUVWXijklmnyz0123" => base24B

We now know that 2 characters of groupA can be represented in base 24. Let convert it into real base 24. Let f be a function mapping each string of groupA[0] and groupB[1] into real base 24 which contains only "0123456789abcdefghijklmn". They can be easily transformed through identical indexes. EX: `IC` means `00`in base 24 sytem and can be translated as zero number in base 10. The zero number is equivalent to `[space][space]` in groupB. The second char of groupB can be represented in terms of the remainder of the number in decimal system divided by `6`. We come up with this formular. Given n is a positive number. `charCode(groupB[1])=(n%6+2)*16` and `charCode(groupB[0])=[n/6]+32`.

#### Part 2: Find the relationship between the 2 last characters in groupA and  the last character of groupB

All the steps in the first part, we has assumed the third characters of sA is fixed. In this case `groupA[2]='A'`. So we now do it in a different way. Let first 2 characters of groupA be fixed and let us run the value of the third one in base62. We've got new hash table:

	TABLE 4
	(Mj0x)=>(2=1)---(77,106,48,120)=>(50,61,49)
	(Mj1x)=>(2=q)---(77,106,49,120)=>(50,61,113)
	(Mj2x)=>(2=�)---(77,106,50,120)=>(50,61,65533)
	(Mj3x)=>(2=�)---(77,106,51,120)=>(50,61,65533)
	(Mj4x)=>(2>1)---(77,106,52,120)=>(50,62,49)
	(Mj5x)=>(2>q)---(77,106,53,120)=>(50,62,113)
	(Mj6x)=>(2>�)---(77,106,54,120)=>(50,62,65533)
	(Mj7x)=>(2>�)---(77,106,55,120)=>(50,62,65533)
	(Mj8x)=>(2?1)---(77,106,56,120)=>(50,63,49)
	(Mj9x)=>(2?q)---(77,106,57,120)=>(50,63,113)
	(MjAx)=>(201)---(77,106,65,120)=>(50,48,49)
	(MjBx)=>(20q)---(77,106,66,120)=>(50,48,113)
	(MjCx)=>(20�)---(77,106,67,120)=>(50,48,65533)
	(MjDx)=>(20�)---(77,106,68,120)=>(50,48,65533)
	..............................................
	(Mjwx)=>(2<1)---(77,106,119,120)=>(50,60,49)
	(Mjxx)=>(2<q)---(77,106,120,120)=>(50,60,113)
	(Mjyx)=>(2<�)---(77,106,121,120)=>(50,60,65533)
	(Mjzx)=>(2<�)---(77,106,122,120)=>(50,60,65533)

Look at these values : (`Mj0x`,`Mj1x`,`Mj2x`,`Mj3x`);(`MjAx`,`MjBx`,`MjCx`,`MjDx`);...;(`Mjwx`,`Mjxx`,`Mjyx`,`Mjzx`). All those 4 values represent the same second character but different on the third one in groupB. Let us split into 3 categories. The first category has `typeA`containing `"0,4,8,A,E,...,w"` resulting the character `1` in `groupB[2]`. The second category has `typeB`containing `"2,5,9,B,...,x"` resulting the character `q` in `groupB[2]`. The last category is "typeC" which ends up with invalid character `�`. One of our assumptions in PART 1 is the `groupB[2]` depends only on `groupA[3]`. Now we have to change our model and let the third character of groupB depend on the third and the fourth characters of groupA. To find the relationship, we have to set `groupA[2]` fixed and be `typeA`. We choose `groupA[2]='A'` and loop through the values of `groupA[3]` in base62. We come to new hash table:

	TABLE 5
	(MjA0)=>(204)---(77,106,65,48)=>(50,48,52)
	(MjA1)=>(205)---(77,106,65,49)=>(50,48,53)
	(MjA2)=>(206)---(77,106,65,50)=>(50,48,54)
	(MjA3)=>(207)---(77,106,65,51)=>(50,48,55)
	(MjA4)=>(208)---(77,106,65,52)=>(50,48,56)
	(MjA5)=>(209)---(77,106,65,53)=>(50,48,57)
	(MjA6)=>(20:)---(77,106,65,54)=>(50,48,58)
	(MjA7)=>(20;)---(77,106,65,55)=>(50,48,59)
	(MjA8)=>(20<)---(77,106,65,56)=>(50,48,60)
	(MjA9)=>(20=)---(77,106,65,57)=>(50,48,61)
	---------------------
	(MjAg)=>(20 )---(77,106,65,103)=>(50,48,32)
	(MjAh)=>(20!)---(77,106,65,104)=>(50,48,33)
	(MjAj)=>(20#)---(77,106,65,106)=>(50,48,35)
	(MjAk)=>(20$)---(77,106,65,107)=>(50,48,36)
	(MjAl)=>(20%)---(77,106,65,108)=>(50,48,37)
	(MjAm)=>(20&)---(77,106,65,109)=>(50,48,38)
	(MjAn)=>(20')---(77,106,65,110)=>(50,48,39)
	(MjAo)=>(20()---(77,106,65,111)=>(50,48,40)
	(MjAp)=>(20))---(77,106,65,112)=>(50,48,41)
	(MjAq)=>(20*)---(77,106,65,113)=>(50,48,42)
	(MjAr)=>(20 )---(77,106,65,114)=>(50,48,32)
	(MjAs)=>(20,)---(77,106,65,115)=>(50,48,44)
	(MjAt)=>(20-)---(77,106,65,116)=>(50,48,45)
	(MjAu)=>(20.)---(77,106,65,117)=>(50,48,46)
	(MjAv)=>(20/)---(77,106,65,118)=>(50,48,47)
	(MjAw)=>(200)---(77,106,65,119)=>(50,48,48)
	(MjAx)=>(201)---(77,106,65,120)=>(50,48,49)
	(MjAy)=>(202)---(77,106,65,121)=>(50,48,50)
	(MjAz)=>(203)---(77,106,65,122)=>(50,48,51)

If the category is `typeA`, if `48<=charCode(groupA[3])<=57` then `charCode(groupB[2])=charCode(groupA[3])+4` and so on We do similar things with `typeB`

	TABLE 6
	(MjB0)=>(20t)---(77,106,66,48)=>(50,48,116)
	(MjB1)=>(20u)---(77,106,66,49)=>(50,48,117)
	(MjB2)=>(20v)---(77,106,66,50)=>(50,48,118)
	(MjB3)=>(20w)---(77,106,66,51)=>(50,48,119)
	(MjB4)=>(20x)---(77,106,66,52)=>(50,48,120)
	(MjB5)=>(20y)---(77,106,66,53)=>(50,48,121)
	(MjB6)=>(20z)---(77,106,66,54)=>(50,48,122)
	(MjB7)=>(20{)---(77,106,66,55)=>(50,48,123)
	(MjB9)=>(20})---(77,106,66,57)=>(50,48,125)
	----------------
	(MjBA)=>(20@)---(77,106,66,65)=>(50,48,64)
	(MjBB)=>(20A)---(77,106,66,66)=>(50,48,65)
	(MjBC)=>(20B)---(77,106,66,67)=>(50,48,66)
	(MjBD)=>(20C)---(77,106,66,68)=>(50,48,67)
	(MjBE)=>(20D)---(77,106,66,69)=>(50,48,68)
	(MjBF)=>(20E)---(77,106,66,70)=>(50,48,69)
	(MjBG)=>(20F)---(77,106,66,71)=>(50,48,70)
	(MjBI)=>(20H)---(77,106,66,73)=>(50,48,72)
	(MjBH)=>(20G)---(77,106,66,72)=>(50,48,71)
	(MjBJ)=>(20I)---(77,106,66,74)=>(50,48,73)
	(MjBK)=>(20J)---(77,106,66,75)=>(50,48,74)
	(MjBL)=>(20K)---(77,106,66,76)=>(50,48,75)
	(MjBM)=>(20L)---(77,106,66,77)=>(50,48,76)
	(MjBN)=>(20M)---(77,106,66,78)=>(50,48,77)
	(MjBO)=>(20N)---(77,106,66,79)=>(50,48,78)
	(MjBP)=>(20O)---(77,106,66,80)=>(50,48,79)
	(MjBQ)=>(20P)---(77,106,66,81)=>(50,48,80)
	(MjBR)=>(20Q)---(77,106,66,82)=>(50,48,81)
	(MjBS)=>(20R)---(77,106,66,83)=>(50,48,82)
	(MjBT)=>(20S)---(77,106,66,84)=>(50,48,83)
	(MjBU)=>(20T)---(77,106,66,85)=>(50,48,84)
	(MjBV)=>(20U)---(77,106,66,86)=>(50,48,85)
	(MjBW)=>(20V)---(77,106,66,87)=>(50,48,86)
	(MjBY)=>(20X)---(77,106,66,89)=>(50,48,88)
	(MjBX)=>(20W)---(77,106,66,88)=>(50,48,87)
	(MjBZ)=>(20Y)---(77,106,66,90)=>(50,48,89)
	----------------
	(MjBa)=>(20Z)---(77,106,66,97)=>(50,48,90)
	(MjBb)=>(20[)---(77,106,66,98)=>(50,48,91)
	(MjBd)=>(20])---(77,106,66,100)=>(50,48,93)
	(MjBe)=>(20^)---(77,106,66,101)=>(50,48,94)
	(MjBf)=>(20_)---(77,106,66,102)=>(50,48,95)
	(MjBg)=>(20`)---(77,106,66,103)=>(50,48,96)
	(MjBh)=>(20a)---(77,106,66,104)=>(50,48,97)
	(MjBj)=>(20c)---(77,106,66,106)=>(50,48,99)
	(MjBi)=>(20b)---(77,106,66,105)=>(50,48,98)
	(MjBk)=>(20d)---(77,106,66,107)=>(50,48,100)
	(MjBl)=>(20e)---(77,106,66,108)=>(50,48,101)
	(MjBo)=>(20h)---(77,106,66,111)=>(50,48,104)
	(MjBn)=>(20g)---(77,106,66,110)=>(50,48,103)
	(MjBm)=>(20f)---(77,106,66,109)=>(50,48,102)
	(MjBp)=>(20i)---(77,106,66,112)=>(50,48,105)
	(MjBq)=>(20j)---(77,106,66,113)=>(50,48,106)
	(MjBs)=>(20l)---(77,106,66,115)=>(50,48,108)
	(MjBt)=>(20m)---(77,106,66,116)=>(50,48,109)
	(MjBr)=>(20k)---(77,106,66,114)=>(50,48,107)
	(MjBu)=>(20n)---(77,106,66,117)=>(50,48,110)
	(MjBv)=>(20o)---(77,106,66,118)=>(50,48,111)
	(MjBx)=>(20q)---(77,106,66,120)=>(50,48,113)
	(MjBw)=>(20p)---(77,106,66,119)=>(50,48,112)
	(MjBy)=>(20r)---(77,106,66,121)=>(50,48,114)
	(MjBz)=>(20s)---(77,106,66,122)=>(50,48,115)

Again, if the category is `typeB`, if `48<=charCode(groupA[3])<=57` then `charCode(groupB[2])=charCode(groupA[3])+68` and so on

#### Part 3: Return to part 1 and find the categories

As we have assumed in part 1, the first 2 characters of groupB is only illustrated in terms the first 2 characters of groupA. However, we have also come to conclusion that the the first 2 of groupB is dependent on the first 3 of groupA. Hence we have to revisit our formular constructed in part 1. We notice that if we find new formular, the new one is linear to the former we've got. For now, just look again the former one:

	charCode(groupB[1])=(n%6+2)*16
	charCode(groupB[0])=[n/6]+32

We observe the new one has to depend on the former one and the categories. Let's look at the TABLE 4 again, but this time, keep in mind we will sort TABLE 4 in order of `charCode(group[1])`. So their values is from `48,49,50,51...63`. We have new TABLE 7

	TABLE 7
	charCode   48 49 50 51 52 53 54 55 56 57 58 59 6+ 61 62 63
	character   0  1  2  3  4  5  6  7  8  9  :  ;  <  =  > ?
	index 		0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15
	typeA		A  E  I  M  Q  U  Y  c  g  k  o  s  w  0  4  8
	typeB		B  F  J  N  R  V  Z  d  h  l  p  t  x  1  5  9
	typeC	   CD GH KL OP ST WX ab ef ij mn qr uv yz 23 67

Finally the new formular is:  
	
	charCode(groupB[1])=(n%6+2)*16 + index
	charCode(groupB[0])=[n/6]+32

The index is determined by the third character of groupA. So if we want to encode the file path into string. The only thing we have to do is to reverse the step.
