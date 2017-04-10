/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package mipsproject;

/**
 *
 * @author anvithasagireddy*/
 
import java.util.Scanner;
public class MipsProject {

    /**
     * @param args the command line arguments*/
     
    public static void main(String[] args) {
        int[] board = {3,3,3,3,3,3,3,3,3,3,0,0,0,0,0,0,0,3,3,0,0,0,0,0,0,0,3,3,0,0,0,0,0,0,0,3,3,0,0,0,0,0,0,0,3,3,0,0,0,0,0,0,0,3,3,0,0,0,0,0,0,0,3,3,3,3,3,3,3,3,3,3};
        Scanner input = new Scanner(System.in);
        int column =0;
        boolean end = false;
        int win = 0;
        int player = 1;
        int rowPlayed = 0;
        boardReader(board);
        while(win == 0){
            System.out.println("Enter a column between 1 and 7");
            column = input.nextInt();
            rowPlayed = place(column, board, player);
            win = wincheck(rowPlayed, board);
            if(player == 1)
                player = 2;
            else if(player == 2)
                player = 1;
            boardReader(board);
            System.out.println(player);
            //end = true;
        }
        }
        public static void boardReader(int[] board){
        for(int i = 0; i < board.length; i++){
            if(board[i] == 0)
                System.out.print("| |");
            else if(board[i] == 1)
                System.out.print("|X|");
            else if(board[i] == 2)
                System.out.print("|O|");
            else if(board[i] == 3)
                System.out.print("-");
            if((i+1)%9==0)
                System.out.print("\n");
    }
        }
        public static int place(int col, int[] board, int player){
            if(board[col+54] == 0){
                board[col+54] = player;
                return col+54;
            }
            else if(board[col+45] == 0){
                board[col+45] = player;
                return col+54;
            }
            else if(board[col+36] == 0){
                board[col+36] = player;
                return col+54;
            }
            else if(board[col+27] == 0){
                board[col+27] = player;
                return col+54;
            }
            else if(board[col+18] == 0){
                board[col+18] = player;
                return col+54;
            }
            else if(board[col+9] == 0){
                board[col+9] = player;
                return col+54;
            }
            else
                System.out.println("The column is full");
            return 0;
        }
        public static int wincheck(int rowPlayed, int[] board){
            int count = 0;
            if(board[rowPlayed] == 2)
                return 1;
            return 0;
        }
    
}


