# int main(void) {
#     for (int row = 0; row < FLAG_ROWS; row++) {
#         for (int col = 0; col < FLAG_COLS; col++) {
#             printf("%c", flag[row][col]);
#         }
#         printf("\n");
#     }
# }
main:



.data
# This label inside the data region refers to the bytes of the flag.
# Note that even thought the bytes are listed on separate lines,
# they are actually stored as a single contiguous chunk or 'string' in memory.
flag:
	.byte '#', '#', '#', '#', '#', '.', '.', '#', '#', '#', '#', '#'
	.byte '#', '#', '#', '#', '#', '.', '.', '#', '#', '#', '#', '#'
	.byte '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.'
	.byte '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.'
	.byte '#', '#', '#', '#', '#', '.', '.', '#', '#', '#', '#', '#'
	.byte '#', '#', '#', '#', '#', '.', '.', '#', '#', '#', '#', '#'


# Todo: implement printf("%c", flag[row][col]]).
# row = $t0, col = $t1.