# Draw-It Drek

Draw-It-Drek is a small robotic arm that can draw things.

Through the use of advanced inverse kinematics, the endpoint of the robotic arm can be moved up, down, left, right, forward, or backward.  By customising the constants, this code can operate a two-segment robotic arm of any size.


## Variables

| Variable | Type | Purpose |
| :-: | :-: | :-- |
| `u` | Constant | Length* of first segment of robotic arm (between base and joint) |
| `v` | Constant | Length* of second segment of robotic arm (between joint and tip of pen or marker) |
| `alpha` | Calculation Output | The angle of segment one running perpendicular to the ground, in degrees |
| `beta` | Dependent Calculation Output | The angle between segment one and segment 2, in degrees |
| `omega` | Dependent Calculation Output | The angle, from an above view, that the entire robotic arm points in - the "base angle", in degrees |
| `x` | Independent Calculation Input | The desired x position* of the tip of the pen or marker at the end of the robotic arm  |
| `y` | Independent Calculation Input | The desired y position* of the tip of the pen or marker at the end of the robotic arm |
| `z` | Independent Calculation Input | The desired height* of the tip of the pen or marker from the plane parallel to the ground and running through the base point of the robotic arm |

####### *Units of length are to be determined by user.  The math will work so long as all length units are in the same units.  We used centimetres.


## Motors
You will need three servo motors, one for each calculated angle (alpha, beta, omega).  You can use any PWM-signal fixed servo motors that support angles from 0 to 180 degrees.  We used 9g micro servo motors, though it is certainly worth noting that such inaccurate and low-torque motors will produce very poor results.  The accuracy of your robotic arm will ultimately be limited by the accuracy and strength of your servo motors.


## Math
For more information on the inverse kinematics equations, see it simulated in [Desmos 3D](https://www.desmos.com/3d/vgpartrk5s).  These formulas were created by [Wesley McGinn](@WesleyMcGinn) and are free for anyone to use.


## Attribution
Please do not use this code for your robotic arm without crediting us.  In other words, if you did not write this code, do not claim that you did.

By no means should this code be used to complete an assignment without explicit notice to the instructor of the course that you did not write the code.