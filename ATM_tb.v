`timescale 1ns/1ns

module ATM_tb;

parameter  P_WIDTH = 16, C_WIDTH = 6, B_WIDTH = 20 ;

reg                       clk_tb ;
reg                       rst_tb ;

reg      [31:0]           threshold ;

reg     [C_WIDTH-1:0]     card_number ;
reg                       card_in ;

reg                       button_0 ;
reg                       button_1 ;
reg                       button_2 ;
reg                       button_3 ;
reg                       button_4 ;
reg                       button_5 ;
reg                       button_6 ;
reg                       button_7 ;
reg                       button_8 ;
reg                       button_9 ;

reg                       enter_button   ;
reg                       cancel_button  ;
reg                       correct_button ;

reg                       withdraw_button ;
reg                       deposit_button  ;
reg                       show_balance    ;

reg                       another_service ;

reg                       English_button  ;
reg                       Arabic_button   ;
//reg                       language ;

reg                       touch_100_button;
reg                       touch_300_button;
reg                       touch_500_button;
reg                       touch_700_button;
reg                       touch_1000_button;
reg                       multiple_100_button;
reg                       multiple_1000_button;

//reg     [B_WIDTH-1:0]     withdraw_value       ;
reg     [B_WIDTH-1:0]     actual_deposit_value ;
//reg     [B_WIDTH-1:0]     chosen_deposit_value ;


wire  [B_WIDTH-1:0]       updated_balance; //output from ATM_FSM and also transmitted to card_handling to update user data

wire                      wrong_password ;

wire                      operation_done ;

wire                      error ;
// lw ktb withdraw aw deposit value 8lt 3 mrat hntl3o bara --> lsa hn discuss


initial 
begin
    // Save Waveform
    $dumpfile("ATM.vcd") ;       
    $dumpvars ; 

    // initialization
    initialize() ;

    // Reset
    reset() ;

    #5
    card_number = 6'b0 ;
    #5
    card_in = 1'b1 ;
    #10
    card_in = 1'b0 ;

                    //************** CHOOSE LANGUAGE ****************
    #20
    English_button = 1'b1 ;
    #10
    English_button = 1'b0 ;

                    //********** ENTER PASSWORD ****************
    #20
    //in_password  = 'b0011_0011_0111_0000 ;
    press_button(4'd3);
    #10
    press_button(4'd3);
    #10
    press_button(4'd7);
    #10
    press_button(4'd0);
    #10
    press_button(4'd11);

    enter();

    #20 
                    //**********   WITHDRAW OPERATION ****************
    
    withdraw_button = 1'b1 ;
    #10
    withdraw_button = 1'b0 ;

    #10
    //withdraw_value = 'd1000 ;

    touch_500_button = 1'b1 ;
    #10
    touch_500_button = 1'b0 ;

    enter();
    #30

                    //**********   ANOTHER SERVICE ****************

    another_service = 1'b1;
    #10
    another_service = 1'b0 ;

    #20
                    //**********   DEPOSIT OPERATION ****************

    deposit_button = 1'b1 ;
    #10
    deposit_button = 1'b0 ;

    #10
    actual_deposit_value = 'd700 ;

    touch_700_button = 1'b1 ;
    #10
    touch_700_button = 1'b0 ;

    //chosen_deposit_value = 'd2000 ;
    
    //deposit_value = 'd2000 ;
    enter();
    #30

                    //**********   ANOTHER SERVICE ****************

    another_service = 1'b1;
    #10
    another_service = 1'b0 ;

    #20

                    //**********   SHOW BALANCE   ****************

    show_balance = 1'b1 ;
    #10
    show_balance = 1'b0 ;

    #30

    cancel_button = 1'b1 ;
    #10
    cancel_button = 1'b0 ;


    ////////////////////// ************** ANOTHER USER WITH WRONG PASSWORD *************** /////////////////////////////

    #5
    card_number = 6'b1 ;
    #5
    card_in = 1'b1 ;
    #10
    card_in = 1'b0 ;

                    //************** CHOOSE LANGUAGE ****************
    #20
    
    English_button = 1'b1 ;
    #10
    English_button = 1'b0 ;

                    //********** ENTER PASSWORD ****************
    #20
    //in_password  = 'b0011_0101_0000_0110 ;
    press_button(4'd3);
    #10
    press_button(4'd5);
    #10
    press_button(4'd0);
    #10
    press_button(4'd7);
    #10
    press_button(4'd11);

    enter();

    #20 

                    //********** ENTER PASSWORD ****************
    #20
    //in_password  = 'b0011_0101_0000_0110 ;
    press_button(4'd3);
    #10
    press_button(4'd5);
    #10
    press_button(4'd0);
    #10
    press_button(4'd6);
    #10
    press_button(4'd11);

    enter();

    #20 

                    //**********   WITHDRAW OPERATION ****************
    
    withdraw_button = 1'b1 ;
    #10
    withdraw_button = 1'b0 ;

    #10
    multiple_100_button = 1'b1 ;
    #10
    multiple_100_button = 1'b0 ;
    
    #10
    press_button('d2);
    #10 
    press_button('d11);

    //withdraw_value = 'd2000 ;
    enter();
    #30

                    //**********   CANCEL   ****************

    cancel_button = 1'b1;
    #10
    cancel_button = 1'b0 ;

    #20



    ////////////////////// ************** ANOTHER USER *************** /////////////////////////////

    #5
    card_number = 6'b10 ;
    #5
    card_in = 1'b1 ;
    #10
    card_in = 1'b0 ;

                    //************** CHOOSE LANGUAGE ****************
    #20
    
    English_button = 1'b1 ;
    #10
    English_button = 1'b0 ;

                    //********** ENTER PASSWORD ****************
    #20
    //in_password  = 'b0100_0000_0111_0110 ;
    press_button(4'd4);
    #10
    press_button(4'd0);
    #10
    press_button(4'd7);
    #10
    press_button(4'd6);
    #10
    press_button(4'd11);

    enter();

    #20 
                    //**********   WITHDRAW OPERATION ****************
    
    withdraw_button = 1'b1 ;
    #10
    withdraw_button = 1'b0 ;

    #10
    multiple_1000_button = 1'b1 ;
    #10
    multiple_1000_button = 1'b0 ;
    
    #10
    press_button('d5);
    #10 
    press_button('d11);

    //withdraw_value = 'd2000 ;
    enter();
    #30

                    //**********   ANOTHER SERVICE ****************

    another_service = 1'b1;
    #10
    another_service = 1'b0 ;

    #20
                    //**********   DEPOSIT OPERATION --> WRONG ****************

    deposit_button = 1'b1 ;
    #10
    deposit_button = 1'b0 ;

    #10
    actual_deposit_value = 'd2000 ;
    //chosen_deposit_value = 'd1000 ;
    #10
    multiple_1000_button = 1'b1 ;
    #10
    multiple_1000_button = 1'b0 ;
    
    #10
    press_button('d3);
    #10 
    press_button('d11);
    
    //deposit_value = 'd2000 ;
    enter();
    #30

                    //**********   DEPOSIT OPERATION --> CORRECT ****************

    deposit_button = 1'b1 ;
    #10
    deposit_button = 1'b0 ;

    #10
    actual_deposit_value = 'd1000 ;
    //chosen_deposit_value = 'd1000 ;
    #10
    multiple_1000_button = 1'b1 ;
    #10
    multiple_1000_button = 1'b0 ;
    
    #10
    press_button('d1);
    #10 
    press_button('d11);
    
    //deposit_value = 'd2000 ;
    enter();
    #30

                    //**********   ANOTHER SERVICE ****************

    another_service = 1'b1;
    #10
    another_service = 1'b0 ;

    #20

                    //**********   SHOW BALANCE   ****************

    show_balance = 1'b1 ;
    #10
    show_balance = 1'b0 ;

    #170

/* 
    ////////////////////// ************** ANOTHER USER WITH RESET PASSWORD *************** /////////////////////////////

    #5
    card_number = 6'b11 ;
    #5
    card_in = 1'b1 ;
    #10
    card_in = 1'b0 ;


                    //********** ENTER PASSWORD ****************
    #20
    //in_password  = 'b0011_0011_0111_0000 ;
    press_button(4'd3);
    #10
    press_button(4'd3);
    #10
    press_button(4'd11);

    correct_button = 1'b1;
    #10
    correct_button = 1'b0 ;

    //enter();

    #20 

                    //********** ENTER PASSWORD ****************
    #20
    //in_password  = 'b0011_0011_0111_0000 ;
    press_button(4'd3);
    #10
    press_button(4'd3);
    #10
    press_button(4'd7);
    #10
    press_button(4'd0);
    #10
    press_button(4'd11);

    enter();
*/
    #20 

    #300
  
    $finish ; 
end


////////////////////////////////////////////////////////
/////////////////////// TASKS //////////////////////////
////////////////////////////////////////////////////////

task reset;
begin
    rst_tb =  'b1;
    #1
    rst_tb  = 'b0;
    #1
    rst_tb  = 'b1;
end
endtask

task initialize;
begin
    clk_tb   = 1'b1 ;

    threshold = 32'd15 ;

    button_0 = 1'b0 ;
    button_1 = 1'b0 ;
    button_2 = 1'b0 ;
    button_3 = 1'b0 ;
    button_4 = 1'b0 ;
    button_5 = 1'b0 ;
    button_6 = 1'b0 ;
    button_7 = 1'b0 ;
    button_8 = 1'b0 ;
    button_9 = 1'b0 ;

    enter_button   = 1'b0 ;
    cancel_button  = 1'b0 ;
    correct_button = 1'b0 ;

    withdraw_button = 1'b0 ;
    deposit_button  = 1'b0 ;
    show_balance    = 1'b0 ;

    another_service = 1'b0 ;

    English_button  = 1'b0 ;
    Arabic_button   = 1'b0 ;

    //withdraw_value       = 'd0;
    actual_deposit_value = 'd0;
    //chosen_deposit_value = 'd0;
end
endtask

task press_button;
input [3:0] button;
begin
    button_0 = 1'b0 ;
    button_1 = 1'b0 ;
    button_2 = 1'b0 ;
    button_3 = 1'b0 ;
    button_4 = 1'b0 ;
    button_5 = 1'b0 ;
    button_6 = 1'b0 ;
    button_7 = 1'b0 ;
    button_8 = 1'b0 ;
    button_9 = 1'b0 ;
    
    case(button)
    4'd0 : button_0 = 1'b1 ;
    4'd1 : button_1 = 1'b1 ;
    4'd2 : button_2 = 1'b1 ;
    4'd3 : button_3 = 1'b1 ;
    4'd4 : button_4 = 1'b1 ;
    4'd5 : button_5 = 1'b1 ;
    4'd6 : button_6 = 1'b1 ;
    4'd7 : button_7 = 1'b1 ;
    4'd8 : button_8 = 1'b1 ;
    4'd9 : button_9 = 1'b1 ;
    default : begin
        button_0 = 1'b0 ;
        button_1 = 1'b0 ;
        button_2 = 1'b0 ;
        button_3 = 1'b0 ;
        button_4 = 1'b0 ;
        button_5 = 1'b0 ;
        button_6 = 1'b0 ;
        button_7 = 1'b0 ;
        button_8 = 1'b0 ;
        button_9 = 1'b0 ;
    end
    endcase
end
endtask

task enter;
begin
    enter_button = 1'b1 ;
    #10
    enter_button = 1'b0 ;
end
endtask
////////////////////////////////////////////////////////
////////////////// Clock Generator  ////////////////////
////////////////////////////////////////////////////////

always #5  clk_tb = !clk_tb ;  

////////////////////////////////////////////////////////
/////////////////// DUT Instantation ///////////////////
////////////////////////////////////////////////////////

ATM_TOP DUT(
    .clk(clk_tb),
    .rst(rst_tb),

    .threshold(threshold),
    .card_number(card_number),
    .card_in(card_in),

    .button_0(button_0),
    .button_1(button_1),
    .button_2(button_2),
    .button_3(button_3),
    .button_4(button_4),
    .button_5(button_5),
    .button_6(button_6),
    .button_7(button_7),
    .button_8(button_8),
    .button_9(button_9),

    .touch_100_button(touch_100_button),
	.touch_300_button(touch_300_button),
	.touch_500_button(touch_500_button),
	.touch_700_button(touch_700_button),
	.touch_1000_button(touch_1000_button),
	.multiple_100_button(multiple_100_button),
	.multiple_1000_button(multiple_1000_button),
    
    .enter_button(enter_button),
    .cancel_button(cancel_button),
    .correct_button(correct_button),

    .withdraw_button(withdraw_button),
    .deposit_button(deposit_button),
    .show_balance(show_balance),

    .another_service(another_service),

    .English_button(English_button),
    .Arabic_button (Arabic_button ),    
    
    //.withdraw_value(withdraw_value),
    .actual_deposit_value(actual_deposit_value),
    //.chosen_deposit_value(chosen_deposit_value),

    .updated_balance(updated_balance),
    .operation_done(operation_done),
    .error(error),
    .wrong_password(wrong_password)

);



endmodule