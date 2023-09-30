`include "ATM_FSM.v"
`include "card_handling.v"
`include "timer.v"
`include "user_interface.v"

module ATM_TOP #(parameter  P_WIDTH = 16,
                            B_WIDTH = 20, 
							C_WIDTH = 6)
							
( 

    input   wire                    clk,
    input   wire                    rst,
	
	//card_handling inputs
	input wire [C_WIDTH-1:0]         card_number,
	input wire                       card_in,
    //user_interface inputs 
	
    input wire                      button_0,
    input wire                      button_1,
    input wire                      button_2,
    input wire                      button_3,
    input wire                      button_4,
    input wire                      button_5,
    input wire                      button_6,
    input wire                      button_7,
    input wire                      button_8,
    input wire                      button_9,

    input wire                      enter_button,
    input wire                      cancel_button,
    //input wire                      correct_button,

    input wire                      withdraw_button,
    input wire                      deposit_button,
    input wire                      show_balance,
	
	input wire                      another_service,

    input wire                      English_button,
    input wire                      Arabic_button,
	

	// input wire                      touch_100_button,
    // input wire                      touch_300_button,
    // input wire                      touch_500_button,
	// input wire                      touch_700_button,
    // input wire                      touch_1000_button,
	input wire                      multiple_100_button,
    input wire                      multiple_1000_button,


    
	//ATM_FSM inputs 
	
    input wire     [B_WIDTH-1:0]     actual_deposit_value,
    //input wire     [B_WIDTH-1:0]     chosen_deposit_value,
	
	//timer input 
	input wire [31:0]                threshold,
	
	
	//output from ATM_FSM

	output wire	                         card_out,
	
	output wire  [B_WIDTH-1:0]     updated_balance, //output from ATM_FSM and also transmitted to card_handling to update user data
	output wire                    operation_done, 
	output wire                    error,
	output wire                    wrong_password
	
	);


//wire  [B_WIDTH-1:0]    		withdraw_value ;
//wire  [B_WIDTH-1:0]         chosen_deposit_value;

wire  [B_WIDTH-1:0]         entry_value;

//wire  [B_WIDTH-1:0]         updated_balance; //output from ATM_FSM to card_handling
wire  [P_WIDTH-1:0]         password;//from card_handling to ATM_FSM
wire  [B_WIDTH-1:0]         balance;//from card_handling to ATM_FSM
wire                        pass_en;//from card_handling to ATM_FSM


//user_interface
wire  [P_WIDTH-1:0]         in_password ; //written password by user is sent to ATM_FSM to check on it and do services
wire  [1:0]                 operation ; //to ATM_FSM to indicate the operation

//timer inputs 
wire                         time_out ; //flag to ATM_FSM that time out the card will be executed (go to idle)

//ATM_FSM
wire                         start_timer ; // to adjust timer (start running time)
wire                         restart_timer; //to reset timer between states 

//wire                         card_out ;

wire     [1:0]               language ;

card_handling U0_card_handling (
    .clk(clk),
    .rst(rst),
	
    .card_number(card_number),
    .card_in(card_in),
	.card_out(card_out),
    
	.updated_balance(updated_balance),

    .password(password),
    .balance(balance),
	.operation_done(operation_done),
    .pass_en(pass_en)
    
);

user_interface U0_user_interface (
    .clk(clk),
    .rst(rst),
	
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
    .card_in(card_in),
	
	// .touch_100_button(touch_100_button),
	// .touch_300_button(touch_300_button),
	// .touch_500_button(touch_500_button),
	// .touch_700_button(touch_700_button),
	// .touch_1000_button(touch_1000_button),
	.multiple_100_button(multiple_100_button),
	.multiple_1000_button(multiple_1000_button),
	
    .enter_button(enter_button),
    .cancel_button(cancel_button),
    // .correct_button(correct_button),
	
    .withdraw_button(withdraw_button),
    .deposit_button(deposit_button),
	.show_balance(show_balance),
	
	.another_service(another_service),

	.English_button(English_button),
	.Arabic_button(Arabic_button),
	//outputs
	.entry_value(entry_value),
	//.entry_value(chosen_deposit_value),
	.in_password(in_password),
	.operation(operation),
	.language(language)

	
);

timer U0_timer (
    .clk(clk),
    .rst(rst),
	
	.restart(restart_timer),
    .start(start_timer),
    .threshold(threshold),
    .time_out(time_out)
    
);

ATM_FSM U0_ATM_FSM (
    .clk(clk),
    .rst(rst),
	
    .time_out(time_out),
    .user_password(password),
    .current_balance(balance),
    .pass_en(pass_en),

	.card_out(card_out),
	
    .in_password(in_password),
    .enter_button(enter_button),
	.cancel_button(cancel_button),
	.correction_button(correct_button),
	.another_service(another_service),
	
	.language(language),
	.operation(operation),
	
	.entry_value(entry_value),
	.actual_deposit_value(actual_deposit_value),
	//.chosen_deposit_value(chosen_deposit_value),
	
	.updated_balance(updated_balance),
	.wrong_password(wrong_password),
	.operation_done(operation_done),
	.error(error),
	.start_timer(start_timer),
	.restart_timer(restart_timer)
    
);


endmodule