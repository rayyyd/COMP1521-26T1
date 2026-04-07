################################################################################
# COMP1521 26T1 -- Assignment 1 -- MIPS Metro!
#
#
# !!! IMPORTANT !!!
# Before starting work on the assignment, make sure you set your tab-width to 8!
# It is also suggested to indent with tabs only.
# Instructions to configure your text editor can be found here:
#   https://cgi.cse.unsw.edu.au/~cs1521/26T1/resources/mips-editors.html
# !!! IMPORTANT !!!
#
# This program was written by Sylvita Fernandes (z5516765)
# on 02/03/2026 onwards
#
# Description: 
# MIPS Metro is an adaptation of Subway Surfers, a runner game where the player navigates a character 
# through a moving track. 
# Instead of being 3D like subway surfers, this is 2D.
# The player must jump over trains, crouch under 
# barriers, avoid walls, and collect cash.
#
# Version 1.0 (2026-03-02): Team COMP1521 <cs1521@cse.unsw.edu.au>
#
################################################################################

#![tabsize(8)]

# ------------------------------------------------------------------------------
#                                   Constants
# ------------------------------------------------------------------------------

# -------------------------------- C Constants ---------------------------------
TRUE = 1
FALSE = 0

JUMP_KEY = 'w'
LEFT_KEY = 'a'
CROUCH_KEY = 's'
RIGHT_KEY = 'd'
TICK_KEY = '\''
QUIT_KEY = 'q'

ACTION_DURATION = 3
CHUNK_DURATION = 10

SCROLL_SCORE_BONUS = 1
TRAIN_SCORE_BONUS = 1
BARRIER_SCORE_BONUS = 2
CASH_SCORE_BONUS = 3

MAP_HEIGHT = 20
MAP_WIDTH = 5
PLAYER_ROW = 1

PLAYER_RUNNING = 0
PLAYER_CROUCHING = 1
PLAYER_JUMPING = 2

STARTING_COLUMN = MAP_WIDTH / 2

TRAIN_CHAR = 't'
BARRIER_CHAR = 'b'
CASH_CHAR = 'c'
EMPTY_CHAR = ' '
WALL_CHAR = 'w'
RAIL_EDGE = '|'

SAFE_CHUNK_INDEX = 0
NUM_CHUNKS = 14

# --------------------- Useful Offset and Size Constants -----------------------

# struct BlockSpawner offsets
BLOCK_SPAWNER_NEXT_BLOCK_OFFSET = 0
BLOCK_SPAWNER_SAFE_COLUMN_OFFSET = 20
BLOCK_SPAWNER_SIZE = 24

# struct Player offsets
PLAYER_COLUMN_OFFSET = 0
PLAYER_STATE_OFFSET = 4
PLAYER_ACTION_TICKS_LEFT_OFFSET = 8
PLAYER_ON_TRAIN_OFFSET = 12
PLAYER_SCORE_OFFSET = 16
PLAYER_SIZE = 20

SIZEOF_PTR = 4

# ------------------------------------------------------------------------------
#                                 Data Segment
# ------------------------------------------------------------------------------
        .data

# !!! DO NOT ADD, REMOVE, OR MODIFY ANY OF THESE DEFINITIONS !!!

# ----------------------------- String Constants -------------------------------

print_welcome__msg_1:
        .asciiz "Welcome to MIPS Metro!\n"
print_welcome__msg_2_1:
        .asciiz "Use the following keys to control your character: ("
print_welcome__msg_2_2:
        .asciiz "):\n"
print_welcome__msg_3:
        .asciiz ": Move left\n"
print_welcome__msg_4:
        .asciiz ": Move right\n"
print_welcome__msg_5_1:
        .asciiz ": Crouch ("
print_welcome__msg_5_2:
        .asciiz ")\n"
print_welcome__msg_6_1:
        .asciiz ": Jump ("
print_welcome__msg_6_2:
        .asciiz ")\n"
print_welcome__msg_7_1:
        .asciiz "or press "
print_welcome__msg_7_2:
        .asciiz " to continue moving forward.\n"
print_welcome__msg_8_1:
        .asciiz "You must crouch under barriers ("
print_welcome__msg_8_2:
        .asciiz ")\n"
print_welcome__msg_9_1:
        .asciiz "and jump over trains ("
print_welcome__msg_9_2:
        .asciiz ").\n"
print_welcome__msg_10_1:
        .asciiz "You should avoid walls ("
print_welcome__msg_10_2:
        .asciiz ") and collect cash ("
print_welcome__msg_10_3:
        .asciiz ").\n"
print_welcome__msg_11:
        .asciiz "On top of collecting cash, running on trains and going under barriers will get you extra points.\n"
print_welcome__msg_12_1:
        .asciiz "When you've had enough, press "
print_welcome__msg_12_2:
        .asciiz " to quit. Have fun!\n"

get_command__invalid_input_msg:
        .asciiz "Invalid input!\n"

main__game_over_msg:
        .asciiz "Game over, thanks for playing 😊!\n"

display_game__score_msg:
        .asciiz "Score: "

handle_collision__barrier_msg:
        .asciiz "💥 You ran into a barrier! 😵\n"
handle_collision__train_msg:
        .asciiz "💥 You ran into a train! 😵\n"
handle_collision__wall_msg:
        .asciiz "💥 You ran into a wall! 😵\n"

maybe_pick_new_chunk__column_msg_1:
        .asciiz "Column "
maybe_pick_new_chunk__column_msg_2:
        .asciiz ": "
maybe_pick_new_chunk__safe_msg:
        .asciiz "New safe column: "

get_seed__prompt_msg:
        .asciiz "Enter a non-zero number for the seed: "
get_seed__prompt_invalid_msg:
        .asciiz "Invalid seed!\n"
get_seed__set_msg:
        .asciiz "Seed set to "

TRAIN_SPRITE:
        .asciiz "🚆"
BARRIER_SPRITE:
        .asciiz "🚧"
CASH_SPRITE:
        .asciiz "💵"
EMPTY_SPRITE:
        .asciiz "  "
WALL_SPRITE:
        .asciiz "🧱"

PLAYER_RUNNING_SPRITE:
        .asciiz "🏃"
PLAYER_CROUCHING_SPRITE:
        .asciiz "🧎"
PLAYER_JUMPING_SPRITE:
        .asciiz "🤸"

# ------------------------------- Chunk Layouts --------------------------------

SAFE_CHUNK: # char[]
        .byte EMPTY_CHAR, EMPTY_CHAR, EMPTY_CHAR, EMPTY_CHAR, EMPTY_CHAR, EMPTY_CHAR, EMPTY_CHAR, EMPTY_CHAR, EMPTY_CHAR, EMPTY_CHAR, '\0',
CHUNK_1: # char[]
        .byte EMPTY_CHAR, CASH_CHAR, EMPTY_CHAR, WALL_CHAR, CASH_CHAR, CASH_CHAR, CASH_CHAR, BARRIER_CHAR, '\0',
CHUNK_2: # char[]
        .byte CASH_CHAR, EMPTY_CHAR, EMPTY_CHAR, EMPTY_CHAR, BARRIER_CHAR, EMPTY_CHAR, EMPTY_CHAR, EMPTY_CHAR, CASH_CHAR, '\0',
CHUNK_3: # char[]
        .byte EMPTY_CHAR, EMPTY_CHAR, EMPTY_CHAR, TRAIN_CHAR, TRAIN_CHAR, TRAIN_CHAR, TRAIN_CHAR, TRAIN_CHAR, TRAIN_CHAR, TRAIN_CHAR, '\0',
CHUNK_4: # char[]
        .byte EMPTY_CHAR, EMPTY_CHAR, EMPTY_CHAR, TRAIN_CHAR, TRAIN_CHAR, TRAIN_CHAR, TRAIN_CHAR, EMPTY_CHAR, CASH_CHAR, '\0',
CHUNK_5: # char[]
        .byte EMPTY_CHAR, EMPTY_CHAR, CASH_CHAR, TRAIN_CHAR, TRAIN_CHAR, TRAIN_CHAR, EMPTY_CHAR, TRAIN_CHAR, EMPTY_CHAR, EMPTY_CHAR, '\0',
CHUNK_6: # char[]
        .byte EMPTY_CHAR, EMPTY_CHAR, CASH_CHAR, BARRIER_CHAR, EMPTY_CHAR, EMPTY_CHAR, CASH_CHAR, CASH_CHAR, EMPTY_CHAR, BARRIER_CHAR, '\0'
CHUNK_7: # char[]
        .byte EMPTY_CHAR, EMPTY_CHAR, EMPTY_CHAR, WALL_CHAR, WALL_CHAR, WALL_CHAR, WALL_CHAR, WALL_CHAR, WALL_CHAR, WALL_CHAR, '\0',
CHUNK_8: # char[]
        .byte CASH_CHAR, EMPTY_CHAR, CASH_CHAR, EMPTY_CHAR, CASH_CHAR, EMPTY_CHAR, CASH_CHAR, EMPTY_CHAR, CASH_CHAR, EMPTY_CHAR, '\0',
CHUNK_9: # char[]
        .byte CASH_CHAR, EMPTY_CHAR, EMPTY_CHAR, WALL_CHAR, TRAIN_CHAR, TRAIN_CHAR, TRAIN_CHAR, TRAIN_CHAR, TRAIN_CHAR, '\0',
CHUNK_10: # char[]
        .byte CASH_CHAR, CASH_CHAR, CASH_CHAR, CASH_CHAR, CASH_CHAR, CASH_CHAR, CASH_CHAR, CASH_CHAR, CASH_CHAR, CASH_CHAR, '\0',
CHUNK_11: # char[]
        .byte EMPTY_CHAR, EMPTY_CHAR, CASH_CHAR, WALL_CHAR, TRAIN_CHAR, TRAIN_CHAR, TRAIN_CHAR, TRAIN_CHAR, '\0',
CHUNK_12: # char[]
        .byte EMPTY_CHAR, EMPTY_CHAR, CASH_CHAR, '\0',
CHUNK_13: # char[]
        .byte EMPTY_CHAR, EMPTY_CHAR, EMPTY_CHAR, WALL_CHAR, WALL_CHAR, '\0',

CHUNKS: # char*[]
        .word SAFE_CHUNK, CHUNK_1, CHUNK_2, CHUNK_3, CHUNK_4, CHUNK_5, CHUNK_6, CHUNK_7, CHUNK_8, CHUNK_9, CHUNK_10, CHUNK_11, CHUNK_12, CHUNK_13

# ----------------------------- Global Variables -------------------------------

g_block_spawner: # struct BlockSpawner
        # char *next_block[MAP_WIDTH], offset 0
        .word 0, 0, 0, 0, 0
        # int safe_column, offset 20
        .word STARTING_COLUMN

g_map: # char[MAP_HEIGHT][MAP_WIDTH]
        .space MAP_HEIGHT * MAP_WIDTH

g_player: # struct Player
        # int column, offset 0
        .word STARTING_COLUMN
        # int state, offset 4
        .word PLAYER_RUNNING
        # int action_ticks_left, offset 8
        .word 0
        # int on_train, offset 12
        .word FALSE
        # int score, offset 16
        .word 0

g_rng_state: # unsigned
        .word 1

# !!! Reminder to not not add to or modify any of the above !!!
# !!! strings or any other part of the data segment.        !!!

# ------------------------------------------------------------------------------
#                                 Text Segment
# ------------------------------------------------------------------------------
        .text

############################################################
####                                                    ####
####   Your journey begins here, intrepid adventurer!   ####
####                                                    ####
############################################################

################################################################################
#
# Implement the following functions,
# and check these boxes as you finish implementing each function.
#
#  SUBSET 0
#  - [ ] print_welcome
#  SUBSET 1
#  - [ ] get_command
#  - [ ] main
#  - [ ] init_map
#  SUBSET 2
#  - [ ] run_game
#  - [ ] display_game
#  - [ ] maybe_print_player
#  - [ ] handle_command
#  SUBSET 3
#  - [ ] handle_collision
#  - [ ] maybe_pick_new_chunk
#  - [ ] do_tick
#  PROVIDED
#  - [X] get_seed
#  - [X] rng
#  - [X] read_char
################################################################################

################################################################################
# .TEXT <print_welcome>
print_welcome:
        # Subset:   0
        #
        # Description: Prints the welcome message and game instructions.
        #
        # Args:     None
        #
        # Returns:  None
        #
        # Frame:    [] based on other prefilled frames
        # Uses:     [$v0, $a0]
        # Clobbers: [$v0, $a0] This will be used over and over again, and not retain it's previous value
        #
        # Locals:
        #   - No local variables:
        #   - There would be no locals as we are just prining out strings
        #
        # Structure:
        #   print_welcome
        #   -> [prologue]
        #     -> body
        #   -> [epilogue]

print_welcome__prologue:
        # Since this program will call other functions, in this particular case
        # $ra does not need to be "saved"
        # Other subsets will require it so that it does not become overwritten
        # we don't need to push or pop $ra just yet
        # Lecture 3, this is a LEAF Function

print_welcome__body:
        # printf("Welcome to MIPS Metro!\n");
        li      $v0, 4
        la      $a0, print_welcome__msg_1
        syscall

        # printf("Use the following keys to control your character: (%s):\n", PLAYER_RUNNING_SPRITE);
        la      $a0, print_welcome__msg_2_1
        syscall

        la      $a0, PLAYER_RUNNING_SPRITE
        syscall

        la      $a0, print_welcome__msg_2_2
        syscall

        # printf("%c: Move left\n", LEFT_KEY);
        li      $v0, 11
        li      $a0, LEFT_KEY
        syscall

        li      $v0, 4
        la      $a0, print_welcome__msg_3
        syscall

        # printf("%c: Move right\n", RIGHT_KEY);
        li      $v0, 11
        li      $a0, RIGHT_KEY
        syscall

        li      $v0, 4
        la      $a0, print_welcome__msg_4
        syscall

        # printf("%c: Crouch (%s)\n", CROUCH_KEY, PLAYER_CROUCHING_SPRITE);
        li      $v0, 11
        li      $a0, CROUCH_KEY
        syscall

        li      $v0, 4
        la      $a0, print_welcome__msg_5_1
        syscall
        
        la      $a0, PLAYER_CROUCHING_SPRITE
        syscall
        
        la      $a0, print_welcome__msg_5_2
        syscall

        # printf("%c: Jump (%s)\n", JUMP_KEY, PLAYER_JUMPING_SPRITE);
        li      $v0, 11
        li      $a0, JUMP_KEY
        syscall

        li      $v0, 4
        la      $a0, print_welcome__msg_6_1
        syscall

        la      $a0, PLAYER_JUMPING_SPRITE
        syscall

        la      $a0, print_welcome__msg_6_2
        syscall

        # printf("or press %c to continue moving forward.\n", TICK_KEY);
        la      $a0, print_welcome__msg_7_1
        syscall

        li      $v0, 11
        li      $a0, TICK_KEY
        syscall

        li      $v0, 4
        la      $a0, print_welcome__msg_7_2
        syscall

        # printf("You must crouch under barriers (%s)\n", BARRIER_SPRITE);
        la      $a0, print_welcome__msg_8_1
        syscall

        la      $a0, BARRIER_SPRITE
        syscall

        la      $a0, print_welcome__msg_8_2
        syscall

        # printf("and jump over trains (%s).\n", TRAIN_SPRITE);
        la      $a0, print_welcome__msg_9_1
        syscall

        la      $a0, TRAIN_SPRITE
        syscall

        la      $a0, print_welcome__msg_9_2
        syscall

        # printf("You should avoid walls (%s) and collect cash (%s).\n", WALL_SPRITE, CASH_SPRITE);
        la      $a0, print_welcome__msg_10_1
        syscall

        la      $a0, WALL_SPRITE
        syscall

        la      $a0, print_welcome__msg_10_2
        syscall

        la      $a0, CASH_SPRITE
        syscall
        
        la      $a0, print_welcome__msg_10_3
        syscall

        # printf( "On top of collecting cash, running on trains and going under barriers " "will get you extra points.\n");
        la      $a0, print_welcome__msg_11
        syscall

        # printf("When you've had enough, press %c to quit. Have fun!\n", QUIT_KEY);
        la      $a0, print_welcome__msg_12_1
        syscall

        li      $v0, 11
        li      $a0, QUIT_KEY
        syscall

        li      $v0, 4
        la      $a0, print_welcome__msg_12_2
        syscall

print_welcome__epilogue:
        jr      $ra

################################################################################
# .TEXT <get_command>
        .text
get_command:
        # Subset:   1
        #
        # Description: Prompts the user and reads a valid command character.
        #
        # Args:     None
        #
        # Returns:  $v0: char
        #
        # Frame:    []
        # Uses:     [$s0, $v0, $t0, $a0]
        # Clobbers: [$v0, $t0, $a0]
        #
        # Locals:
        #   - char input = $s0 -- line 510
        #
        # Structure:
        #   Use the structure in simplify C break it down 
        #   get_command
        #   -> [prologue]
        #     -> body
	#     -> done
        #   -> [epilogue]

get_command__prologue:
        begin   
        push    $ra
        push    $s0

get_command__body:
        # char input = read_char();
        jal     read_char               # jump to read_char function
        move    $s0, $v0                # input = read_char(); 

        # if (input == QUIT_KEY) return input;
        li      $t0, QUIT_KEY
        beq     $s0, $t0, get_command_done

        # if (input == JUMP_KEY) return input;
        li      $t0, JUMP_KEY
        beq     $s0, $t0, get_command_done

        # if (input == LEFT_KEY ) return input;
        li      $t0, LEFT_KEY
        beq     $s0, $t0, get_command_done

        # if (input == CROUCH_KEY) return input;
        li      $t0, CROUCH_KEY
        beq     $s0, $t0, get_command_done

        # if (input == RIGHT_KEY) return input;
        li      $t0, RIGHT_KEY
        beq     $s0, $t0, get_command_done

        # if (input == TICK_KEY) return input;
        li      $t0, TICK_KEY
        beq     $s0, $t0, get_command_done

        # printf("Invalid input!\n");
        li      $v0, 4                  # syscall 4: print_string
        la      $a0, get_command__invalid_input_msg
        syscall

        # goto get_command_body;
        j       get_command__body

get_command_done:
        move    $v0, $s0                # return input; <--- this one we are focusing on

get_command__epilogue:
        pop     $s0
        pop     $ra
        end

        jr      $ra                     # return;

################################################################################
# .TEXT <main>
        .text
main:
        # Subset:   1
        #
        # Description: The main entry point. Initializes the map and runs the loop.
        #
        # Args:     None
        #
        # Returns:  $v0: int
        #
        # Frame:    [$ra, $s0, $s1]
        # Uses:     [$s0, $s1, $a0, $a1, $a2, $a3, $v0]
        # Clobbers: [$a0, $a1, $a2, $a3, $v0]
        #
        # Locals:
        #   - $s0: char command
        #   - $s1: int result
        # Structure:
        #   main
        #   -> [prologue]
        #     -> body
	#     -> loop_start
        #   -> [epilogue]

main__prologue:
        begin
        push    $ra
        push    $s0
        push    $s1

main__body:
        # print_welcome();
        jal     print_welcome

        # get_seed();
        jal     get_seed

        # init_map(g_map);
        la      $a0, g_map              # arg 0: pass address of g_map
        jal     init_map

main__game_loop_start:
        # display_game(g_map, &g_player);
        la      $a0, g_map              # arg 0: g_map
        la      $a1, g_player           # arg 1: &g_player
        jal     display_game            # jumps to function display_game         

        # char command = get_command();
        jal     get_command             # jumps to function get_command
        move    $s0, $v0                # command = get_command()

        # int result = run_game( );
        la      $a0, g_map              # arg 0: g_map
        la      $a1, g_player           # arg 1: &g_player
        la      $a2, g_block_spawner    # arg 2: &g_block_spawner
        move    $a3, $s0                # arg 3: command
        
        jal     run_game
        move    $s1, $v0                # result = run_game()

        # if (result != 0) goto game_loop_start;
        bnez    $s1, main__game_loop_start

        # printf("Game over, thanks for playing 😊!\n");
        li      $v0, 4                  # syscall 4: print_string
        la      $a0, main__game_over_msg
        syscall

        li      $v0, 0                  # return 0;

main__epilogue: 
        pop     $s1
        pop     $s0
        pop     $ra
        end

        jr      $ra

################################################################################
# .TEXT <init_map>
        .text
init_map:
        # Subset:   1
        #
        # Description: Initializes the map grid and populates hardcoded blocks.
        #
        # Args:
        #   - $a0: char map[MAP_HEIGHT][MAP_WIDTH]
        #
        # Returns:  None
        #
        # Frame:    [] 
        # Uses:     [$a0, $t0, $t1, $t2, $t3, $t4]
        # Clobbers: [$t0, $t1, $t2, $t3, $t4]
        #
        # Locals:
        #   - $t0: row counter (i)
        #   - $t1: col counter (j)
        #   - $t2: temp register for loop bounds and math
        #   - $t3: the actual char being stored (empty, wall, train, etc.)
        #   - $t4: target memory address for map[i][j]
        #
        # Structure:
        #   init_map
        #   -> [prologue]
        #     -> body
        #       -> init_map_outer
        #       -> init_map_inner
        #       -> init_map_inner_done
        #       -> init_map_done
        #   -> [epilogue]

init_map__prologue:
        # No function calls made ---> No need to save $ra 

init_map__body:
        li      $t0, 0                  # int i = 0;

init_map_outer:
        li      $t2, MAP_HEIGHT
        bge     $t0, $t2, init_map_done # if (i >= MAP_HEIGHT) goto init_map_done;

        li      $t1, 0                  # int j = 0;

init_map_inner:
        li      $t2, MAP_WIDTH
        bge     $t1, $t2, init_map_inner_done # if (j >= MAP_WIDTH) goto init_map_inner_done;

        # Calculate offset: (i * MAP_WIDTH) + j
        mul     $t2, $t0, MAP_WIDTH     # i * 5
        add     $t2, $t2, $t1           # (i * 5) + j
    
        # Calculate address: map + offset
        add     $t4, $a0, $t2           # Base address + offset
        
        li      $t3, EMPTY_CHAR
        sb      $t3, 0($t4)             # map[i][j] = EMPTY_CHAR;

        addi    $t1, $t1, 1             # j++;
        j       init_map_inner

init_map_inner_done:
        addi    $t0, $t0, 1             # i++;
        j       init_map_outer

init_map_done:
        # Hardcoded test values
        # map[6][0] = WALL_CHAR
        li      $t1, 6
        mul     $t2, $t1, MAP_WIDTH     # 6 * MAP_WIDTH
        add     $t4, $a0, $t2           # base address + offset
        li      $t3, WALL_CHAR
        sb      $t3, 0($t4)             # drop wall char into memory

        # map[6][1] = TRAIN_CHAR
        li      $t1, 6
        mul     $t2, $t1, MAP_WIDTH     # 6 * MAP_WIDTH
        addi    $t2, $t2, 1             # + 1 col
        add     $t4, $a0, $t2               
        li      $t3, TRAIN_CHAR
        sb      $t3, 0($t4)                 

        # map[6][2] = CASH_CHAR
        li      $t1, 6
        mul     $t2, $t1, MAP_WIDTH     # 6 * MAP_WIDTH
        addi    $t2, $t2, 2             # + 2 cols
        add     $t4, $a0, $t2               
        li      $t3, CASH_CHAR
        sb      $t3, 0($t4)                 

        # map[8][2] = BARRIER_CHAR
        li      $t1, 8
        mul     $t2, $t1, MAP_WIDTH     # 8 * MAP_WIDTH
        addi    $t2, $t2, 2             # + 2 cols
        add     $t4, $a0, $t2               
        li      $t3, BARRIER_CHAR
        sb      $t3, 0($t4)

init_map__epilogue:
        jr      $ra

################################################################################
# .TEXT <run_game>
        .text
run_game:
        # Subset:   2
        #
        # Description: Executes a single turn of the game based on user input.
        #
        # Args:
        #   - $a0: char map[MAP_HEIGHT][MAP_WIDTH]
        #   - $a1: struct Player *player
        #   - $a2: struct BlockSpawner *block_spawner
        #   - $a3: char input
        #
        # Returns:  $v0: int
        #
        # Frame:    [$ra, $s0, $s1]
        # Uses:     [$a0, $a1, $a2, $a3, $v0, $s0, $s1, $t0]
        # Clobbers: [$a0, $a1, $a2, $a3, $v0, $t0]
        #
        # Locals:
        #   - $s0: saved map pointer
        #   - $s1: saved player pointer
        #
        # Structure:
        #   run_game
        #   -> [prologue]
        #     -> body
        #       -> quit
        #   -> [epilogue]

run_game__prologue:
        begin
        push    $ra
        push    $s0
        push    $s1

run_game__body:
        # Check QUIT_KEY
        li      $t0, QUIT_KEY
        beq     $a3, $t0, run_game_quit
        
        # Before jumping to handle_command function, must save registers 
        # So those args don't get overwritten
        move    $s0, $a0                # Save map pointer
        move    $s1, $a1                # Save player pointer

        # handle_command(map, player, block_spawner, input);
        # Args $a0, $a1, $a2, $a3 are already set correctly from run_game's entry.
        jal     handle_command

        # handle_collision(map, player);
        move    $a0, $s0                # Restore map pointer to $a0
        move    $a1, $s1                # Restore player pointer to $a1
        jal     handle_collision        

        # handle_collision returns the status in $v0. 
        # We can just leave it there and return.
        j       run_game__epilogue

run_game_quit:
        li      $v0, FALSE              # return FALSE (0)

run_game__epilogue:
        # FIXED: Epilogue needs 'pop' to restore registers! 
        # Make sure to pop in the exact reverse order.
        pop     $s1
        pop     $s0
        pop     $ra
        end

        jr      $ra                     # return;

################################################################################
# .TEXT <display_game>
        .text
display_game:
        # Subset:   2
        #
        # Description: Renders the current state of the game map, player, and score.
        #
        # Args:
        #   - $a0: char map[MAP_HEIGHT][MAP_WIDTH]
        #   - $a1: struct Player *player
        #
        # Returns:  None
        #
        # Frame:    [$ra, $s0, $s1, $s2, $s3]
        # Uses:     [$a0, $a1, $a2, $v0, $s0, $s1, $s2, $s3, $t1, $t2, $t3, $t4]
        # Clobbers: [$a0, $a1, $a2, $v0, $t1, $t2, $t3, $t4]
        #
        # Locals:
        #   - $s0: map pointer
        #   - $s1: player pointer
        #   - $s2: int i
        #   - $s3: int j
	# Structure:
        #   display_game
	#   -> display_game_start
        #   -> [prologue]
        #   -> loop_body
	#   -> outer_loop
	#   -> inner_loop
	#   -> if_player_here_cond
	#   -> print
        #   -> print_if_done
	#   -> display_done
        #   -> [epilogue]

display_game__start:
        #Saving functions not requred maybe req
        # Register Allocation is needed because we are calling functions that utilise the same variables
        # It will get overwritten if we do not do this step
        begin 
        push    $ra                     # save $ra
        push    $s0                     # save $s0 = map
        push    $s1                     # save $s1 = player
        push    $s2                     # save $s2 = i
        push    $s3                     # save $s3 = j

display_game__prologue: 
        begin 
        # saving all these to the stack so my loop counters and pointers 
        # don't get wiped out when I call other functions later
        push    $ra                     # save $ra (return address)
        push    $s0                     # save $s0 = map
        push    $s1                     # save $s1 = player
        push    $s2                     # save $s2 = i (row)
        push    $s3                     # save $s3 = j (col)

display_loop_body: 
        # stash the arguments into $s registers
        move    $s0, $a0                # Save map pointer
        move    $s1, $a1                # Save player pointer

        # start printing from the very top row and go down
        # int i = MAP_HEIGHT - 1; 
        li      $s2, MAP_HEIGHT 
        addi    $s2, $s2, -1 

display_outer_loop: 
        # if (i < 0) then player hit the bottom of the board, so its done
        bltz    $s2, display_done 
        li      $s3, 0                  # reset j = 0 for the new row

display_inner_loop: 
        # if (j >= MAP_WIDTH) player hits the edge of the row, move to next
        li      $t1, MAP_WIDTH 
        bge     $s3, $t1, display_inner_done 

        # print the left wall of the track
        # putchar(RAIL_EDGE); 
        li      $v0, 11                 # syscall 11 prints a single character
        li      $a0, RAIL_EDGE 
        syscall 

        # set up arguments for the function call: $a0=player, $a1=row, $a2=col
        # int player_was_here = maybe_print_player(player, i, j); 
        move    $a0, $s1 
        move    $a1, $s2 
        move    $a2, $s3 
        jal     maybe_print_player      # jump and link (saves return address automatically)

        # if it returned true (not false/0), the player is here and skip the map char
        bne     $v0, FALSE, display_print_if_done 

        #(row * width) + col
        # Calculate offset: (i * MAP_WIDTH) + j 
        # using $s2 for i 
        mul     $t2, $s2, MAP_WIDTH     # row * width
        add     $t2, $t2, $s3           # + col

        # Calculate address: map + offset 
        add     $t4, $s0, $t2           # add our offset to the base memory address of the map

        # grab the actual character from that memory spot
        # map[i][j] char 
        lb      $t3, 0($t4)             # lb (load byte) because chars are only 1 byte long!

display_if_player_here_conds: 
        # big if/else chain: compare the char we loaded ($t3) to our constants
        li      $t1, EMPTY_CHAR 
        beq     $t3, $t1, print_empty 
        li      $t1, BARRIER_CHAR 
        beq     $t3, $t1, print_barrier 
        li      $t1, TRAIN_CHAR 
        beq     $t3, $t1, print_train 
        li      $t1, CASH_CHAR 
        beq     $t3, $t1, print_money 
        li      $t1, WALL_CHAR 
        beq     $t3, $t1, print_wall 

        # syscall 4 prints a string. load the address (la) of the emoji and print it
print_empty: 
        li      $v0, 4 
        la      $a0, EMPTY_SPRITE 
        syscall 
        j       display_print_if_done   # jump so we don't accidentally print the next sprite too

print_barrier: 
        li      $v0, 4 
        la      $a0, BARRIER_SPRITE 
        syscall 
        j       display_print_if_done 

print_train: 
        li      $v0, 4 
        la      $a0, TRAIN_SPRITE 
        syscall 
        j       display_print_if_done 

print_money: 
        li      $v0, 4 
        la      $a0, CASH_SPRITE 
        syscall 
        j       display_print_if_done 

print_wall: 
        li      $v0, 4 
        la      $a0, WALL_SPRITE 
        syscall 

display_print_if_done: 
        # print the right wall of the track
        li      $v0, 11 
        li      $a0, RAIL_EDGE 
        syscall 

        addi    $s3, $s3, 1             # j++ (move to next column)
        j       display_inner_loop 

display_inner_done: 
        # print a newline to drop down on the terminal
        li      $v0, 11 
        li      $a0, '\n' 
        syscall 

        addi    $s2, $s2, -1            # i-- (move down to next row)
        j       display_outer_loop 

display_done: 
        # print the "Score: " text
        li      $v0, 4 
        la      $a0, display_game__score_msg 
        syscall 

        # print the actual score integer
        li      $v0, 1                  # syscall 1 prints an integer
        # grab the score from the player struct memory block using the offset constant
        lw      $a0, PLAYER_SCORE_OFFSET($s1) # player->score 
        syscall 

        # final newline to keep terminal clean
        li      $v0, 11 
        li      $a0, '\n' 
        syscall 

display_game__epilogue: 
        # pop everything off the stack in the exact reverse order I pushed it
        pop     $s3 
        pop     $s2 
        pop     $s1 
        pop     $s0 
        pop     $ra 
        end 
        
        jr      $ra

################################################################################
# .TEXT <maybe_print_player>
        .text
maybe_print_player:
        # Subset:   2
        #
        # Description: Checks if the player is at the given row and column. If so, 
        #              prints the appropriate player sprite based on their state.
        #
        # Args:
        #   - $a0: struct Player *player
        #   - $a1: int row
        #   - $a2: int column
        #
        # Returns:  $v0: int (TRUE if player was printed, FALSE otherwise)
        #
        # Frame:    [$ra]
        # Uses:     [$a0, $a1, $a2, $v0, $t0, $t1, $t2]
        # Clobbers: [$v0, $a0, $t0, $t1, $t2]
        #
        # Locals:
        #   - $t0: temporary register for constants (PLAYER_ROW, states)
        #   - $t1: player->column
        #   - $t2: player->state
        #
        # Structure:
        #   maybe_print_player
        #   -> [prologue]
        #     -> body
        #   -> [epilogue]

maybe_print_player__prologue:
        begin              
        push    $ra                     # Save $ra because we call printf (syscall 4)

maybe_print_player__body:
        # if (row != PLAYER_ROW) goto player_not_here;
        # from display i= MAP_Height (rows) and j =map width (cols)
        # I think that we should use the ARGS instead of s1...
        # All ints are 4 bytes each
        li      $t0, PLAYER_ROW
        bne     $a1, $t0, maybe_print_player_is_not_here

        # if (column != player->column) goto player_not_here;
        # $a2: int column
        # we need to offset because we are comparing the column to the player
        lw      $t1, PLAYER_COLUMN_OFFSET($a0)      
        bne     $a2, $t1, maybe_print_player_is_not_here

        # int state = player->state;
        # we need to offset because we are comparing the state to the player
        lw      $t2, PLAYER_STATE_OFFSET($a0)

maybe_print_player_running:
        # if (state == PLAYER_RUNNING) {printf(PLAYER_RUNNING_SPRITE);
        li      $t0, PLAYER_RUNNING
        bne     $t2, $t0, maybe_print_player_crouching

        li      $v0, 4
        la      $a0, PLAYER_RUNNING_SPRITE
        syscall

        # Because this is printed.. return true
        j       maybe_print_player_is_here

maybe_print_player_crouching:
        # else if (state == PLAYER_CROUCHING) { printf(PLAYER_CROUCHING_SPRITE);} 
        li      $t0, PLAYER_CROUCHING
        bne     $t2, $t0, maybe_print_player_jumping

        li      $v0, 4
        la      $a0, PLAYER_CROUCHING_SPRITE
        syscall

        # Because this is printed.. return true
        j       maybe_print_player_is_here

maybe_print_player_jumping:
        # else if (state == PLAYER_JUMPING) {printf(PLAYER_JUMPING_SPRITE);}
        # There's no need to add this as its an else-if statement 
        # It has to be jumping if its not running or crouching

        li      $v0, 4
        la      $a0, PLAYER_JUMPING_SPRITE
        syscall

        j       maybe_print_player_is_here

maybe_print_player_is_here:
        # Return TRUE (1)
        li      $v0, TRUE
        j       maybe_print_player__epilogue
        
maybe_print_player_is_not_here:
        # Return FALSE (0)
        li      $v0, FALSE
        j       maybe_print_player__epilogue

maybe_print_player__epilogue:
        pop     $ra
        end
        
        jr      $ra
################################################################################
# .TEXT <handle_command>
        .text
handle_command:
        # Subset:   2
        #
        # Description: Adjusts the player's position/state based on the user's input.
        #
        # Args:
        #   - $a0: char map[MAP_HEIGHT][MAP_WIDTH]
        #   - $a1: struct Player *player
        #   - $a2: struct BlockSpawner *block_spawner
        #   - $a3: char input
        #
        # Returns:  None
        #
        # Frame:    [$ra, $s0, $s1, $s2, $s3]
        # Uses:     [$a0, $a1, $a2, $a3, $s0, $s1, $s2, $s3, $t0, $t1, $t2]
        # Clobbers: [$a0, $a1, $a2, $t0, $t1, $t2]
        #
        # Locals:
        #   - $s0: map array
        #   - $s1: player struct
        #   - $s2: block_spawner struct
        #   - $s3: input char
        #   - $t1, $t2: temp registers for column, state, and bounds checks
        #
        # Structure:
        #   handle_command
        #   -> [prologue]
        #     -> body
        #       -> check_left
        #       -> check_right
        #       -> check_jump
        #       -> check_crouch
        #       -> check_tick
        #   -> end (epilogue)

handle_command__prologue:
        # save registers
        begin                           # Setup frame pointer
        push    $ra             
        push    $s0                     # char map[MAP_HEIGHT][MAP_WIDTH]  
        push    $s1                     # struct Player *player
        push    $s2                     # struct BlockSpawner *block_spawner
        push    $s3                     # char input

handle_command__body:
        # Move Args because of the do_tick function 
        move    $s0, $a0                # $s0 map array
        move    $s1, $a1                # $s1 player struct
        move    $s2, $a2
        move    $s3, $a3

handle_command__check_left:
        # if (input != LEFT_KEY) goto check_right;
        li      $t1, LEFT_KEY
        bne     $a3, $t1, handle_command__check_right

        # if (player->column <= 0) goto end;
        lw      $t1, PLAYER_COLUMN_OFFSET($s1)
        blez    $t1, handle_command__end

        # player->column--;
        addi    $t1, $t1, -1
        sw      $t1, PLAYER_COLUMN_OFFSET($s1)
        j       handle_command__end

handle_command__check_right:
        # if (input != RIGHT_KEY) goto check_jump;
        li      $t1, RIGHT_KEY
        bne     $a3, $t1, handle_command__check_jump

        # if (player->column >= MAP_WIDTH - 1) goto end;
        lw      $t1, PLAYER_COLUMN_OFFSET($s1)
        li      $t2, MAP_WIDTH
        addi    $t2, $t2, -1            # MAP_WIDTH - 1
        bge     $t1, $t2, handle_command__end

        # player->column++;
        addi    $t1, $t1, 1
        sw      $t1, PLAYER_COLUMN_OFFSET($s1)
        j       handle_command__end
        
handle_command__check_jump:
        # if (input != JUMP_KEY) goto check_crouch;
        li      $t0, JUMP_KEY
        bne     $s3, $t0, handle_command__check_crouch

        # if (player->state != PLAYER_RUNNING) goto end;
        lw      $t1, PLAYER_STATE_OFFSET($s1)
        li      $t2, PLAYER_RUNNING
        bne     $t1, $t2, handle_command__end

        # player->state = PLAYER_JUMPING;
        li      $t2, PLAYER_JUMPING
        sw      $t2, PLAYER_STATE_OFFSET($s1)

        # player->action_ticks_left = ACTION_DURATION;
        li      $t2, ACTION_DURATION
        sw      $t2, PLAYER_ACTION_TICKS_LEFT_OFFSET($s1)
        j       handle_command__end

handle_command__check_crouch:
        # if (input != CROUCH_KEY) goto check_tick;
        li      $t0, CROUCH_KEY
        bne     $s3, $t0, handle_command__check_tick

        # if (player->state != PLAYER_RUNNING) goto end;
        lw      $t1, PLAYER_STATE_OFFSET($s1)
        li      $t2, PLAYER_RUNNING
        bne     $t1, $t2, handle_command__end

        # player->state = PLAYER_CROUCHING;
        li      $t2, PLAYER_CROUCHING
        sw      $t2, PLAYER_STATE_OFFSET($s1)

        # player->action_ticks_left = ACTION_DURATION;
        li      $t2, ACTION_DURATION
        sw      $t2, PLAYER_ACTION_TICKS_LEFT_OFFSET($s1)
        j       handle_command__end

handle_command__check_tick:
        # if (input != TICK_KEY) goto end;
        li      $t0, TICK_KEY
        bne     $s3, $t0, handle_command__end

        # do_tick(map, player, block_spawner);
        move    $a0, $s0
        move    $a1, $s1
        move    $a2, $s2
        jal     do_tick

handle_command__end:
        # Restore registers
        pop     $s3
        pop     $s2
        pop     $s1
        pop     $s0
        pop     $ra
        end

        jr      $ra
################################################################################
# .TEXT <handle_collision>
        .text
handle_collision:
        # Subset:   3
        #
        # Description: Detects and resolves collision events with map entities.
        #
        # Args:
        #   - $a0: char map[MAP_HEIGHT][MAP_WIDTH]
        #   - $a1: struct Player *player
        #
        # Returns:  $v0: int
        #
        # Frame:    [...]
        # Uses:     [...]
        # Clobbers: [...]
        #
        # Locals:
        #   - ...
        #
        # Structure:
        #   handle_collision
        #   -> [prologue]
        #     -> body
        #   -> [epilogue]

handle_collision__prologue:
        # Save Registers
	begin 
	push 	$ra
        push    $s0                     # Save map pointer
        push    $s1                     # Save player pointer

handle_collision__body:
        # preserve Args
        move    $s0, $a0                # map
        move    $s1, $a1                # player

        # int col = player->column;
        lw      $t0, PLAYER_COLUMN_OFFSET($s1)

        # char map_char = map[PLAYER_ROW][col];
        # Offset = (PLAYER_ROW * MAP_WIDTH) + col
        li      $t1, PLAYER_ROW
        li      $t2, MAP_WIDTH
        mul     $t1, $t1, $t2           # PLAYER_ROW * 5
        add     $t1, $t1, $t0           # t1 = offset
        add     $t2, $s0, $t1           # t2 = base address + offset
        lb      $t3, 0($t2)             # t3 = map_char

        # if (map_char != BARRIER_CHAR) goto check_train;
        li      $t4, BARRIER_CHAR
        bne     $t3, $t4, handle_collision_check_train

        # // Check if player is in the crouching state
        # if (player->state == PLAYER_CROUCHING) goto barrier_pass;
        lw      $t5, PLAYER_STATE_OFFSET($s1)
        li      $t6, PLAYER_CROUCHING
        beq     $t5, $t6, handle_collision_barrier_pass

        # printf("💥 You ran into a barrier! 😵\n");
	li      $v0, 4
        la      $a0, handle_collision__barrier_msg


        # return FALSE;
	li      $v0, FALSE
        j       handle_collision__epilogue

handle_collision_barrier_pass:
        # player->score += BARRIER_SCORE_BONUS; 1
	# player->score 2
	# player->score =  player->score + BARRIER_SCORE_BONUS; 3

	lw      $t4, PLAYER_SCORE_OFFSET($s1)
	addi    $t4, $t4, BARRIER_SCORE_BONUS
	sw      $t4, PLAYER_SCORE_OFFSET($s1)

	# Not on train now, as moving forward
	j       handle_collision_no_train



handle_collision_check_train:
	li      $t4, TRAIN_CHAR
        bne     $t3, $t4, handle_collision_no_train

	# Check if player->state == PLAYER_JUMPING
	lw      $t5, PLAYER_STATE_OFFSET($s1)
        li      $t6, PLAYER_JUMPING
        beq     $t5, $t6, handle_collision_check_safe_train


	# Check if player->on_train == TRUE

	lw      $t5, PLAYER_ON_TRAIN_OFFSET($s1)
        li      $t6, TRUE
        beq     $t5, $t6, handle_collision_check_safe_train

	# Print train crash message 
	li      $v0, 4
        la      $a0, handle_collision__train_msg
        syscall

	#return False
	li      $v0, FALSE
        j       handle_collision__epilogue



        

handle_collision_check_safe_train:

	# player->on_train = TRUE;
        li      $t4, TRUE
        sw      $t4, PLAYER_ON_TRAIN_OFFSET($s1)
        j       handle_collision_exit
	
	# Check if player->state == PLAYER_JUMPING
        lw      $t5, PLAYER_STATE_OFFSET($s1)
        li      $t6, PLAYER_JUMPING
        beq     $t5, $t6, handle_collision_check_wall

	# player->score += TRAIN_SCORE_BONUS; 1
	# player->score 2
	# player->score =  player->score + TRAIN_SCORE_BOONUS; 3
        lw      $t4, TRAIN_SCORE_BONUS($s1)
        addi    $t4, $t4, TRAIN_SCORE_BONUS
        sw      $t4, PLAYER_ON_TRAIN_OFFSET($s1)




handle_collision_no_train:
	# player->on_train = FALSE;
        li      $t4, FALSE
        sw      $t4, PLAYER_ON_TRAIN_OFFSET($s1)

handle_collision_check_wall:
	# if (map_char != WALL_CHAR) goto check_cash;
	li      $t4, WALL_CHAR
        bne     $t3, $t4, handle_collision_cash_check
	
	# Print wall crash message 
        li      $v0, 4
        la      $a0, handle_collision__wall_msg
        syscall

	#return False
        li      $v0, FALSE
        j       handle_collision__epilogue


handle_collision_cash_check:
	# if (map_char != CASH_CHAR) goto collision_exit;
	li      $t4, CASH_CHAR
        bne     $t3, $t4, handle_collision_exit

	# player->score += CASH_SCORE_BONUS;
	lw      $t4, PLAYER_SCORE_OFFSET($s1)
        addi    $t4, $t4, CASH_SCORE_BONUS
        sw      $t4, PLAYER_SCORE_OFFSET($s1)

	# map[PLAYER_ROW][col] = EMPTY_CHAR;
	li      $t4, EMPTY_CHAR
        sb      $t4, 0($t2)		# $t2 is address
					# #t3 is map_char


handle_collision_exit:
	li      $v0, TRUE

handle_collision__epilogue:
        jr      $ra

################################################################################
# .TEXT <maybe_pick_new_chunk>
        .text
maybe_pick_new_chunk:
        # Subset:   3
        #
        # Description: Checks spawner queue and dynamically assigns new map chunks.
        #
        # Args:
        #   - $a0: struct BlockSpawner *block_spawner
        #
        # Returns:  None
        #
        # Frame:    [...]
        # Uses:     [...]
        # Clobbers: [...]
        #
        # Locals:
        #   - $s0: block_spawner ptr
        #   - $s1: new_safe_column_required (0 = false, 1 = true)
        #   - $s2: int column (for loop counter)
        #   - $s3: temp save for chunk / safe_column across syscalls
        # Structure:
        #   maybe_pick_new_chunk
        #   -> [prologue]
        #     -> body
        #   -> [epilogue]

maybe_pick_new_chunk__prologue:
        begin
        push    $ra
        push    $s1
	push	$s2
	push 	$s3
        
maybe_pick_new_chunk__body:
        # Move Args
        move    $s0, $a0                # $s0 = block_spawner
        li      $s1, FALSE              # new_safe_column_required = 0

        li      $s2, FALSE              # int column = 0
maybe_pick_new_chunk__loop:
        #column < MAP_WIDTH; ++column
        li      $t0, MAP_WIDTH
        bge     $s2, $t0, maybe_pick_new_chunk__pick_new

        # char const **next_block_ptr = &block_spawner->next_block[column];

        # if (*next_block_ptr && **next_block_ptr)
        # block_spawner is pointing to next_block
        # *next_block is the first pointer
        # double pointer **next block
        mul     $t0, $s2, 4
        add     $t0, $s0, $t0           # $t0 is address of next_block[column], 

        # *next_block is the first pointer
        lw      $t1, 0($t0)             
        beq     $t1, FALSE, maybe_pick_new_chunk__pick_new

        # double pointer **next block
        lb      $t2, 0($t1)
        beq     $t2, FALSE, maybe_pick_new_chunk__pick_new

        j       maybe_pick_new_chunk__loop

maybe_pick_new_chunk__pick_new:
        # int chunk = rng() % NUM_CHUNKS;
        jal     rng
        li      $t0, NUM_CHUNKS
        rem     $s3, $v0, $t0

        # printf("Column %d: %d\n", column, chunk);
        li      $v0, 4
        la      $a0, maybe_pick_new_chunk__column_msg_1
        syscall 

        li      $v0, 1
        move    $a0, $s2                # print the column counter
        syscall

        li      $v0, 4
        la      $a0, maybe_pick_new_chunk__column_msg_2
        syscall
        
        li      $v0, 1
        move    $a0, $s3                # print the random chunk number
        syscall

        li      $v0, 11
        li      $a0, '\n'
        syscall

        # *next_block_ptr = CHUNKS[chunk];
        # We need to find the new address of *next_block_ptr 
        # As we saved it in a temp register
        mul     $t0, $s2, 4
        add     $t0, $s0, $t0           # line 1436 where $t0 is address of next_block[column],
                                        # $t0 = &block_spawner->next_block[column]
        
        # Find address of CHUNKS
        la      $t1, CHUNKS
        mul     $t2, $s3, 4             # chunk * 4 bytes
        add     $t1, $t1, $t2           # $t1 = address of CHUNKS[chunk]
        lw      $t2, 0($t1)             # $t2 = string pointer at CHUNKS[chunk]

        sw      $t2, 0($t0)             # save it back into the spawner array

        # if (column == block_spawner->safe_column)
        lw      $t3, BLOCK_SPAWNER_SAFE_COLUMN_OFFSET($s0) # Pointing the safe column at the block spawner
        bne     $s2, $t3, maybe_pick_new_chunk_cloop

        # new_safe_column_required = TRUE;
        li      $s1, TRUE

maybe_pick_new_chunk_cloop:
        addi    $s2, $s2, 1             # column++
        j       maybe_pick_new_chunk__loop

maybe_pick_new_safe_column:
        # if (new_safe_column_required)
        beq     $s1, FALSE, maybe_pick_new_chunk__epilogue
        
        # int safe_column = rng() % MAP_WIDTH;
        # don't need to save or move registers
        jal     rng
        li      $t0, MAP_WIDTH
        rem     $s3, $v0, $t0           # $s3 = safe_column

        # printf("New safe column: %d\n", safe_column);
        li      $v0, 4
        la      $a0, maybe_pick_new_chunk__safe_msg
        syscall

        li      $v0, 1
        move    $a0, $s3                # print safe_column
        syscall

        li      $v0, 11
        li      $a0, '\n'
        syscall

        # block_spawner->safe_column = safe_column;
        # blockspawner is pointing to safe column
        # $s3 = address
        sw      $s3, BLOCK_SPAWNER_SAFE_COLUMN_OFFSET($s0)

        # block_spawner->next_block[safe_column] = CHUNKS[SAFE_CHUNK_INDEX];
	



        # calculate the address of safe chunk address first 

maybe_pick_new_chunk__epilogue:

	pop     $s3
        pop     $s2
        pop     $s1
        pop     $s0
        pop     $ra
        end

        jr      $ra

################################################################################
# .TEXT <do_tick>
        .text
do_tick:
        # Subset:   3
        #
        # Description: Evaluates physics, shifts the map, and advances the game tick.
        #
        # Args:
        #   - $a0: char map[MAP_HEIGHT][MAP_WIDTH]
        #   - $a1: struct Player *player
        #   - $a2: struct BlockSpawner *block_spawner
        #
        # Returns:  None
        #
        # Frame:    [...]
        # Uses:     [...]
        # Clobbers: [...]
        #
        # Locals:
        #   - ...
        #
        # Structure:
        #   do_tick
        #   -> [prologue]
        #     -> body
        #   -> [epilogue]

do_tick__prologue:
        begin 
        push	$ra    

do_tick__body:
        # we havem 3 arguments 
        move    $s0, $a0                # map
        move    $s1, $a1                # player
        move    $s2, $a2                # block_spawner

        # if (player->action_ticks_left > 0)
        lw      $t0, PLAYER_ACTION_TICKS_LEFT_OFFSET($s1)
        blez    $t0, do_tick_zero_state

        # --player->action_ticks_left;
        addi    $t0, $t0, -1
        sw      $t0, PLAYER_ACTION_TICKS_LEFT_OFFSET($s1)
        j       do_tick_add_score_bonus

do_tick_zero_state:
        # else { player->state = PLAYER_RUNNING; }
        li      $t0, PLAYER_RUNNING
        sw      $t0, PLAYER_STATE_OFFSET($s1)

do_tick_add_score_bonus:
        # player->score += SCROLL_SCORE_BONUS;
        lw      $t0, PLAYER_SCORE_OFFSET($s1)
        addi    $t0, $t0, SCROLL_SCORE_BONUS
        sw      $t0, PLAYER_SCORE_OFFSET($s1)

        #move args
        #jump to maybe_pick_new_chunk

        #int i = 0
        #i < MAP_HEIGHT - 1; ++i

        # int j = 0;
        # j < MAP_WIDTH; ++j

        # map[i][j] = map[i + 1][j];
        # calculate offset 
        #

        # // Use the block spawner to generate the next row

        # int column = 0
        # column < MAP_WIDTH; ++column

        # char const **next_block = &block_spawner->next_block[column];

        # // Hint: The next line is equivalent to the following 2 lines:

        # // 1. map[MAP_HEIGHT - 1][column] = **next_block;

        # // 2. ++*next_block;


        # map[MAP_HEIGHT - 1][column] = *(*next_block)++;




do_tick__epilogue:
        pop	$ra
        end

        jr 	$ra

################################################################################
################################################################################
###                   PROVIDED FUNCTIONS — DO NOT CHANGE                     ###
################################################################################
################################################################################

################################################################################
# .TEXT <get_seed>
get_seed:
        # Description: Reads and sets a random number seed provided by the user.
        #
        # Args:     None
        #
        # Returns:  None
        #
        # Frame:    []
        # Uses:     [$v0, $a0]
        # Clobbers: [$v0, $a0]
        #
        # Locals:
        #   - $v0: seed
        #
        # Structure:
        #   get_seed
        #   -> [prologue]
        #     -> body
        #       -> invalid_seed
        #       -> seed_ok
        #   -> [epilogue]

get_seed__prologue:
get_seed__body:
        li      $v0, 4                  # syscall 4: print_string
        la      $a0, get_seed__prompt_msg
        syscall                         # printf("Enter a non-zero number for the seed: ")

        li      $v0, 5                  # syscall 5: read_int
        syscall                         # scanf("%d", &seed);
        sw      $v0, g_rng_state        # g_rng_state = seed;

        bnez    $v0, get_seed__seed_ok  # if (seed == 0) {
get_seed__invalid_seed:
        li      $v0, 4                  # syscall 4: print_string
        la      $a0, get_seed__prompt_invalid_msg
        syscall                         # printf("Invalid seed!\n");

        li      $v0, 10                 # syscall 10: exit
        li      $a0, 1
        syscall                         # exit(1);

get_seed__seed_ok:                      # }
        li      $v0, 4                  # sycall 4: print_string
        la      $a0, get_seed__set_msg
        syscall                         # printf("Seed set to ");

        li      $v0, 1                  # syscall 1: print_int
        lw      $a0, g_rng_state
        syscall                         # printf("%d", g_rng_state);

        li      $v0, 11                 # syscall 11: print_char
        la      $a0, '\n'
        syscall                         # putchar('\n');

get_seed__epilogue:
        jr      $ra                     # return;

################################################################################
# .TEXT <rng>
rng:
        # Description: Generates the next random number based on the seed.
        #
        # Args:     None
        #
        # Returns:  $v0: unsigned
        #
        # Frame:    []
        # Uses:     [$v0, $a0, $t0, $t1, $t2]
        # Clobbers: [$v0, $a0, $t0, $t1, $t2]
        #
        # Locals:
        #   - $t0 = copy of g_rng_state
        #   - $t1 = bit
        #   - $t2 = temporary register for bit operations
        #
        # Structure:
        #   rng
        #   -> [prologue]
        #     -> body
        #   -> [epilogue]

rng__prologue:
rng__body:
        lw      $t0, g_rng_state

        srl     $t1, $t0, 31            # g_rng_state >> 31
        srl     $t2, $t0, 30            # g_rng_state >> 30
        xor     $t1, $t2                # bit = (g_rng_state >> 31) ^ (g_rng_state >> 30)

        srl     $t2, $t0, 28            # g_rng_state >> 28
        xor     $t1, $t2                # bit ^= (g_rng_state >> 28)

        srl     $t2, $t0, 0             # g_rng_state >> 0
        xor     $t1, $t2                # bit ^= (g_rng_state >> 0)

        sll     $t1, 31                 # bit << 31
        srl     $t0, 1                  # g_rng_state >> 1
        or      $t0, $t1                # g_rng_state = (g_rng_state >> 1) | (bit << 31)

        sw      $t0, g_rng_state        # store g_rng_state

        move    $v0, $t0                # return g_rng_state

rng__epilogue:
        jr      $ra

################################################################################
# .TEXT <read_char>
read_char:
        # Description: Prompts syscall to retrieve a single char from stdin.
        #
        # Args:     None
        #
        # Returns:  $v0: unsigned
        #
        # Frame:    []
        # Uses:     [$v0]
        # Clobbers: [$v0]
        #
        # Locals:   None
        #
        # Structure:
        #   read_char
        #   -> [prologue]
        #     -> body
        #   -> [epilogue]

read_char__prologue:
read_char__body:
        li      $v0, 12                 # syscall 12: read_char
        syscall                         # return getchar();

read_char__epilogue:
        jr      $ra