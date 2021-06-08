turtles-own
[
  to_left; amount of chemical 45 degrees to beetle's left
  to_right; amount of chemical 45 degrees to beetle's right
  debug
]

globals
[
  beetles; number of beetles
  max_chemical; maximal value of chemical
  max_density; maximal number of beetles per patch
  time; elapsed time
]

patches-own
[
  chemical ; amount of chemical present in patch
  border? ; whether or not patch is on the border
]

;-------------------------------------------------------------------------------------

to setup

  ;; (for this model to work with NetLogo's new plotting features,
  ;; __clear-all-and-reset-ticks should be replaced with clear-all at
  ;; the beginning of your setup procedure and reset-ticks at the end
  ;; of the procedure.)
  ;;__clear-all-and-reset-ticks ; clears display, turtles, and patches
  clear-all
  set time 0 ; resets time to zero

  set max_density 3 ; specifies maximum beetle density

  ask patches
  [
    set chemical 0 ; resets patches' chemical to zero

    ; (below) identifies border patches on edge of screen
    set border? ( pxcor * pxcor + pycor * pycor ) >= ( max-pxcor * max-pxcor )
  ]
  set beetles number ; creates turtles, colors them blue, and distributes

  crt beetles ; them randomly in a circle

  ask turtles
  [
    set color blue
    set heading random 360
    fd int sqrt random ( max-pxcor * max-pxcor )
  ]
  set-current-plot "plot"
  clear-plot ; configures plot color and axes ranges
  ;set-current-plot-pen "pp1"
  set-plot-pen-color blue
  plot-pen-down
  set-plot-y-range 0 number
  set-plot-x-range 0 200 clear-output ; displays color key in command window
  show "|---- KEY TO COLORS -----|" show "| |" show "|black - empty border |" show "|yellow - pheromone, |" show "| brightness |" show "| proportional to|" show "| concentration |"
  reset-ticks
end

;------------------------------------------------------------------------------------------

to go

  set time time + 1 ; increments time

  ask turtles
  [
    set chemical chemical + 1 ; beetles drop 100 units of chemical on patch below
  ]

  repeat diffusion ; diffuses chemical a specified number of times, each
  [
    diffuse chemical 0.2 ; patch sharing 20% of its chemical with 8 neighbors
  ]

  ask patches
  [
    if ( border? = true ); border patches are cleared of chemical to prevent
    [
      set chemical 0
    ]
  ] ; the diffusion from wrapping around the screen

  set max_chemical max [chemical] of patches ; colors patches according to relative concentration
  ask patches
  [
    set pcolor scale-color yellow chemical 0 max_chemical ; of chemical
    ; (below) surveys the amount of chemical to left and right
    if border? [ set pcolor 32 ]
  ]


  ask turtles
  [
    set debug 0
    set to_right [chemical] of patch-at sin ( heading + 45 ) cos ( heading + 45 )
    set to_left [chemical] of patch-at sin ( heading - 45 ) cos ( heading - 45 )
    ifelse ( abs ( to_left - to_right ) ) > ( threshold / 100 ) ; if the chemical concentrations to the left and
    [
      ifelse (to_left > to_right) ; right differ by an amount greater than
      [lt 45] ; "threshold", the beetle turns towards the higher
      [rt 45] ; concentration...
      set debug 1
      if ( count turtles-at dx dy ) < max_density
      [fd .5]
    ] ; and moves forward 1/2 step if the density is low
    [
      lt random 90 ; otherwise, beetles wiggle randomly and...
      rt random 90
      ifelse ( [border?] of patch pxcor pycor ) or ( ( count turtles-at dx dy ) > max_density )
      [rt 180] ; turn around if they are crowded or at the border
      [fd .5]
    ] ; move forward 1/2 step if the path is clear
    ; (below) plots beetles that are dense and clustered

  plotxy time count turtles with [debug = 1]
; plot-point time debug-of turtle 0
]
end

;------------------------------------------------------------------------------------------

to draw

 ; (below) if the mouse is depressed in an area inside the border where the turtle density is less than
 ; max_density, a turtle is created at that point. It is then colored blue, and the graph axis is
 ; adjusted for the new number of turtles

  if mouse-down? [
    ask patch int mouse-xcor int mouse-ycor [
      if ((not ([border?] of patch int mouse-xcor int mouse-ycor ) and ( count turtles-at mouse-xcor mouse-ycor < max_density ))) [
        sprout 1
        ask turtle beetles [setxy mouse-xcor mouse-ycor]
        ask turtle beetles [set color blue]
        set-plot-y-range 0 beetles
        set beetles beetles + 1
        wait 0.1
      ]
    ]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
405
10
905
511
-1
-1
9.65
1
10
1
1
1
0
1
1
1
-25
25
-25
25
0
0
1
ticks
30.0

BUTTON
312
10
376
43
NIL
Setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
43
10
290
43
Number
Number
0
500
498.0
3
1
NIL
HORIZONTAL

SLIDER
43
48
291
81
Threshold
Threshold
0
10
5.0
1
1
NIL
HORIZONTAL

SLIDER
43
91
292
124
Diffusion
Diffusion
1
50
17.0
2
1
NIL
HORIZONTAL

PLOT
21
157
313
356
plot
NIL
NIL
0.0
100.0
0.0
100.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" ""

BUTTON
311
52
374
85
NIL
Go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
311
90
374
123
NIL
Draw
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
## WHAT IS IT?

The eggs of Dendroctonus beetles are laid in batches beneath the bark  
of spruce trees. Larvae hatch from the eggs and feed as a group, side  
by side, on the phloem tissues just inside the bark of the tree. An  
attractive pheromone has been identified as a mechanism for this  
aggregation; each beetle releases the pheromone into the environment  
and moves up the chemical gradient (if it is large enough to detect.)

In this model, each beetle follows these rules:

   - if the concentration of chemical to the diagonal right (1 step

     ahead at 45 degrees) differs from the concentration to the
     diagonal left by an amount greater than "threshold" (a slider
     variable), the beetle turns 45 degrees towards the higher
     concentration

   - if the gradient is undetectable, the beetle wiggles randomly

   - beetles take 1/2 step forward with each time step, unless the

     region is on the edge or is too dense with other beetles

   - beetles secrete 1 unit of chemical per time step, and the chemical

     diffuses to an extent governed by the slider "diffusion"


## HOW TO USE IT

The SETUP button initializes the turtles, patches, plot, and  
command center.

The DRAW button allows the user to place beetles on the board with the  
mouse. The plot axis is also updated for the increased number of beetles.

The GO button sets the simulation in motion, according to the rules  
described above. The display window shows the beetles motion, while the  
plot window shows the degree of clustering over time.

The TIME monitor indicates the number of elapsed time steps.

The NUMBER slider controls the number of beetles in the simulation.

The THRESHOLD slider sets the smallest difference in chemical concentration  
that a beetle can detect; it is in -tenths- of a unit, such that a value  
of 5 represents 0.5 in the program.

The DIFFUSION slider controls how many times the chemical diffuses with each  
time step. A single diffusion consists of each patch sharing 20% of its  
chemical with its eight neighboring patches.

## THINGS TO NOTICE

The model illustrates two results that are observed experimentally: 1) the  
aggregation time is proportional to the initial density, and there is a  
critical density below which a cluster does not form, and 2) starting with  
a small cluster on one side of the screen (with the use of the DRAW button)  
"pulls" the final cluster towards that locale. Otherwise, the cluster  
usually forms close to the center.

The model is somewhat sensitive to the parameter values of threshold and  
diffusion; adjusting them can cause multiple clusters or other behavior.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

ant
true
0
Polygon -7500403 true true 136 61 129 46 144 30 119 45 124 60 114 82 97 37 132 10 93 36 111 84 127 105 172 105 189 84 208 35 171 11 202 35 204 37 186 82 177 60 180 44 159 32 170 44 165 60
Polygon -7500403 true true 150 95 135 103 139 117 125 149 137 180 135 196 150 204 166 195 161 180 174 150 158 116 164 102
Polygon -7500403 true true 149 186 128 197 114 232 134 270 149 282 166 270 185 232 171 195 149 186
Polygon -7500403 true true 225 66 230 107 159 122 161 127 234 111 236 106
Polygon -7500403 true true 78 58 99 116 139 123 137 128 95 119
Polygon -7500403 true true 48 103 90 147 129 147 130 151 86 151
Polygon -7500403 true true 65 224 92 171 134 160 135 164 95 175
Polygon -7500403 true true 235 222 210 170 163 162 161 166 208 174
Polygon -7500403 true true 249 107 211 147 168 147 168 150 213 150

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

bee
true
0
Polygon -1184463 true false 152 149 77 163 67 195 67 211 74 234 85 252 100 264 116 276 134 286 151 300 167 285 182 278 206 260 220 242 226 218 226 195 222 166
Polygon -16777216 true false 150 149 128 151 114 151 98 145 80 122 80 103 81 83 95 67 117 58 141 54 151 53 177 55 195 66 207 82 211 94 211 116 204 139 189 149 171 152
Polygon -7500403 true true 151 54 119 59 96 60 81 50 78 39 87 25 103 18 115 23 121 13 150 1 180 14 189 23 197 17 210 19 222 30 222 44 212 57 192 58
Polygon -16777216 true false 70 185 74 171 223 172 224 186
Polygon -16777216 true false 67 211 71 226 224 226 225 211 67 211
Polygon -16777216 true false 91 257 106 269 195 269 211 255
Line -1 false 144 100 70 87
Line -1 false 70 87 45 87
Line -1 false 45 86 26 97
Line -1 false 26 96 22 115
Line -1 false 22 115 25 130
Line -1 false 26 131 37 141
Line -1 false 37 141 55 144
Line -1 false 55 143 143 101
Line -1 false 141 100 227 138
Line -1 false 227 138 241 137
Line -1 false 241 137 249 129
Line -1 false 249 129 254 110
Line -1 false 253 108 248 97
Line -1 false 249 95 235 82
Line -1 false 235 82 144 100

bird1
false
0
Polygon -7500403 true true 2 6 2 39 270 298 297 298 299 271 187 160 279 75 276 22 100 67 31 0

bird2
false
0
Polygon -7500403 true true 2 4 33 4 298 270 298 298 272 298 155 184 117 289 61 295 61 105 0 43

boat1
false
0
Polygon -1 true false 63 162 90 207 223 207 290 162
Rectangle -6459832 true false 150 32 157 162
Polygon -13345367 true false 150 34 131 49 145 47 147 48 149 49
Polygon -7500403 true true 158 33 230 157 182 150 169 151 157 156
Polygon -7500403 true true 149 55 88 143 103 139 111 136 117 139 126 145 130 147 139 147 146 146 149 55

boat2
false
0
Polygon -1 true false 63 162 90 207 223 207 290 162
Rectangle -6459832 true false 150 32 157 162
Polygon -13345367 true false 150 34 131 49 145 47 147 48 149 49
Polygon -7500403 true true 157 54 175 79 174 96 185 102 178 112 194 124 196 131 190 139 192 146 211 151 216 154 157 154
Polygon -7500403 true true 150 74 146 91 139 99 143 114 141 123 137 126 131 129 132 139 142 136 126 142 119 147 148 147

boat3
false
0
Polygon -1 true false 63 162 90 207 223 207 290 162
Rectangle -6459832 true false 150 32 157 162
Polygon -13345367 true false 150 34 131 49 145 47 147 48 149 49
Polygon -7500403 true true 158 37 172 45 188 59 202 79 217 109 220 130 218 147 204 156 158 156 161 142 170 123 170 102 169 88 165 62
Polygon -7500403 true true 149 66 142 78 139 96 141 111 146 139 148 147 110 147 113 131 118 106 126 71

box
true
0
Polygon -7500403 true true 45 255 255 255 255 45 45 45

butterfly1
true
0
Polygon -16777216 true false 151 76 138 91 138 284 150 296 162 286 162 91
Polygon -7500403 true true 164 106 184 79 205 61 236 48 259 53 279 86 287 119 289 158 278 177 256 182 164 181
Polygon -7500403 true true 136 110 119 82 110 71 85 61 59 48 36 56 17 88 6 115 2 147 15 178 134 178
Polygon -7500403 true true 46 181 28 227 50 255 77 273 112 283 135 274 135 180
Polygon -7500403 true true 165 185 254 184 272 224 255 251 236 267 191 283 164 276
Line -7500403 true 167 47 159 82
Line -7500403 true 136 47 145 81
Circle -7500403 true true 165 45 8
Circle -7500403 true true 134 45 6
Circle -7500403 true true 133 44 7
Circle -7500403 true true 133 43 8

circle
false
0
Circle -7500403 true true 35 35 230

person
false
0
Circle -7500403 true true 155 20 63
Rectangle -7500403 true true 158 79 217 164
Polygon -7500403 true true 158 81 110 129 131 143 158 109 165 110
Polygon -7500403 true true 216 83 267 123 248 143 215 107
Polygon -7500403 true true 167 163 145 234 183 234 183 163
Polygon -7500403 true true 195 163 195 233 227 233 206 159

sheep
false
15
Rectangle -1 true true 90 75 270 225
Circle -1 true true 15 75 150
Rectangle -16777216 true false 81 225 134 286
Rectangle -16777216 true false 180 225 238 285
Circle -16777216 true false 1 88 92

spacecraft
true
0
Polygon -7500403 true true 150 0 180 135 255 255 225 240 150 180 75 240 45 255 120 135

thin-arrow
true
0
Polygon -7500403 true true 150 0 0 150 120 150 120 293 180 293 180 150 300 150

truck-down
false
0
Polygon -7500403 true true 225 30 225 270 120 270 105 210 60 180 45 30 105 60 105 30
Polygon -8630108 true false 195 75 195 120 240 120 240 75
Polygon -8630108 true false 195 225 195 180 240 180 240 225

truck-left
false
0
Polygon -7500403 true true 120 135 225 135 225 210 75 210 75 165 105 165
Polygon -8630108 true false 90 210 105 225 120 210
Polygon -8630108 true false 180 210 195 225 210 210

truck-right
false
0
Polygon -7500403 true true 180 135 75 135 75 210 225 210 225 165 195 165
Polygon -8630108 true false 210 210 195 225 180 210
Polygon -8630108 true false 120 210 105 225 90 210

turtle
true
0
Polygon -7500403 true true 138 75 162 75 165 105 225 105 225 142 195 135 195 187 225 195 225 225 195 217 195 202 105 202 105 217 75 225 75 195 105 187 105 135 75 142 75 105 135 105

wolf
false
0
Rectangle -7500403 true true 15 105 105 165
Rectangle -7500403 true true 45 90 105 105
Polygon -7500403 true true 60 90 83 44 104 90
Polygon -16777216 true false 67 90 82 59 97 89
Rectangle -1 true false 48 93 59 105
Rectangle -16777216 true false 51 96 55 101
Rectangle -16777216 true false 0 121 15 135
Rectangle -16777216 true false 15 136 60 151
Polygon -1 true false 15 136 23 149 31 136
Polygon -1 true false 30 151 37 136 43 151
Rectangle -7500403 true true 105 120 263 195
Rectangle -7500403 true true 108 195 259 201
Rectangle -7500403 true true 114 201 252 210
Rectangle -7500403 true true 120 210 243 214
Rectangle -7500403 true true 115 114 255 120
Rectangle -7500403 true true 128 108 248 114
Rectangle -7500403 true true 150 105 225 108
Rectangle -7500403 true true 132 214 155 270
Rectangle -7500403 true true 110 260 132 270
Rectangle -7500403 true true 210 214 232 270
Rectangle -7500403 true true 189 260 210 270
Line -7500403 true 263 127 281 155
Line -7500403 true 281 155 281 192

wolf-left
false
3
Polygon -6459832 true true 117 97 91 74 66 74 60 85 36 85 38 92 44 97 62 97 81 117 84 134 92 147 109 152 136 144 174 144 174 103 143 103 134 97
Polygon -6459832 true true 87 80 79 55 76 79
Polygon -6459832 true true 81 75 70 58 73 82
Polygon -6459832 true true 99 131 76 152 76 163 96 182 104 182 109 173 102 167 99 173 87 159 104 140
Polygon -6459832 true true 107 138 107 186 98 190 99 196 112 196 115 190
Polygon -6459832 true true 116 140 114 189 105 137
Rectangle -6459832 true true 109 150 114 192
Rectangle -6459832 true true 111 143 116 191
Polygon -6459832 true true 168 106 184 98 205 98 218 115 218 137 186 164 196 176 195 194 178 195 178 183 188 183 169 164 173 144
Polygon -6459832 true true 207 140 200 163 206 175 207 192 193 189 192 177 198 176 185 150
Polygon -6459832 true true 214 134 203 168 192 148
Polygon -6459832 true true 204 151 203 176 193 148
Polygon -6459832 true true 207 103 221 98 236 101 243 115 243 128 256 142 239 143 233 133 225 115 214 114

wolf-right
false
3
Polygon -6459832 true true 170 127 200 93 231 93 237 103 262 103 261 113 253 119 231 119 215 143 213 160 208 173 189 187 169 190 154 190 126 180 106 171 72 171 73 126 122 126 144 123 159 123
Polygon -6459832 true true 201 99 214 69 215 99
Polygon -6459832 true true 207 98 223 71 220 101
Polygon -6459832 true true 184 172 189 234 203 238 203 246 187 247 180 239 171 180
Polygon -6459832 true true 197 174 204 220 218 224 219 234 201 232 195 225 179 179
Polygon -6459832 true true 78 167 95 187 95 208 79 220 92 234 98 235 100 249 81 246 76 241 61 212 65 195 52 170 45 150 44 128 55 121 69 121 81 135
Polygon -6459832 true true 48 143 58 141
Polygon -6459832 true true 46 136 68 137
Polygon -6459832 true true 45 129 35 142 37 159 53 192 47 210 62 238 80 237
Line -16777216 false 74 237 59 213
Line -16777216 false 59 213 59 212
Line -16777216 false 58 211 67 192
Polygon -6459832 true true 38 138 66 149
Polygon -6459832 true true 46 128 33 120 21 118 11 123 3 138 5 160 13 178 9 192 0 199 20 196 25 179 24 161 25 148 45 140
Polygon -6459832 true true 67 122 96 126 63 144
@#$#@#$#@
NetLogo 6.0.3
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
