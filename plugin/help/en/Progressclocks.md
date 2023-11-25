# Progress Clocks

The Progress Clocks plugin allows you to create, update, delete, and list progress clocks. 

## Create Clock

### Syntax:

clock/create [Type] "Name" Current_Value [Max_Value]

### Description:

The `clock/create` command allows you to create a new progress clock. 

- `Type`: Optional. The type of the clock. If 'Scene', the clock will automatically be assigned to the scene number of the room you're currently in.
- `"Name"`: The name of the clock enclosed in quotes.
- `Current_Value`: The starting amount of segments filled in the clock.
- `Max_Value`: The total amount of segments the clock has. 

If only one value input is given, it will assume that is the maximum and start a clock with no filled segments.

### Examples:

`clock/create Scene "Too Much Fire" 6`

This will create a 6 segment empty clock titled 'Too Much Fire' and assign it to your current scene.

`Clock/create/private Downtime "Researching The Void" 2 8`

This will create a private clock titled 'Researching The Void' with two segments out of eight already filled without sending an emit to the room or any scenes. Note: Guides and Staff can always check up on any clocks to see progress.





