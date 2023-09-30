module ATM_FSM #(parameter  P_WIDTH = 16,
                            B_WIDTH = 20 )
(
    input wire              clk,
    input wire              rst,

    // timer input
    input wire                       time_out,

    // card_handling inputs
    input wire     [P_WIDTH-1:0]     user_password,
    input wire     [B_WIDTH-1:0]     current_balance,
    input wire                       pass_en,

    // user's inputs 
    input wire     [P_WIDTH-1:0]     in_password,

    input wire                       enter_button,
    input wire                       cancel_button,
    input wire                       correction_button,


    input wire                       another_service,

    input wire     [1:0]             language,      // English --> 2'b01
                                                    // Arabic  --> 2'b10
    
    input wire     [1:0]             operation,     // operation is transmitted from user_interface    
                                             	    // withdraw --> 00
                                                    // deposit  --> 01
                                                    // balance  --> 10

    //input wire     [B_WIDTH-1:0]     withdraw_value,
    input wire     [B_WIDTH-1:0]     actual_deposit_value,
    //input wire     [B_WIDTH-1:0]     chosen_deposit_value,
    input wire     [B_WIDTH-1:0]     entry_value,

    output reg     [B_WIDTH-1:0]     updated_balance,
    output reg                       wrong_password,

    output reg                       operation_done, //used to ask after it if user need a new service or not 
    output reg                       error, // lw ktb withdraw aw deposit value 8lt 3 mrat hntl3o bara --> lsa hn discuss

    output reg                       start_timer, // to adjust timer (start running time)
    output wire                      restart_timer, // to reset timer between states 

    output reg                       card_out
);


localparam          IDLE             = 4'b0000 ,
                    LANGUAGE         = 4'b0001 ,
                    WRITE_PASS       = 4'b0010 ,
                    CHECK_PASS       = 4'b0011 ,
                    OPERATION        = 4'b0100 ,
                    WRITE_WITHDRAW   = 4'b0101 ,
                    WITHDRAW         = 4'b0110 ,
                    WRITE_DEPOSIT    = 4'b0111 ,
                    DEPOSIT          = 4'b1000 ,
                    BALANCE          = 4'b1001 ;


reg      [3:0]      current_state ,
                    next_state ;


reg      [B_WIDTH-1:0]     updated_balance_comb ;


reg      [1:0]    error_count = 'b0 ;
reg      [1:0]    error_count_reg ;

always @(posedge clk or negedge rst) 
begin
    if(!rst)
    begin
        error_count_reg <= 'b0 ;
    end
    else
    begin
        error_count_reg <= error_count ;
    end
end

always @(posedge clk or negedge rst) 
begin
    if(!rst)
    begin
        updated_balance <= 'b0 ;
    end
    else
    begin
        if(pass_en)
        begin
            updated_balance <= current_balance ;
        end
        else
        begin
            updated_balance <= updated_balance_comb ;
        end
    end   
end


//state transition
always @ (posedge clk or negedge rst)
begin
    if(!rst)
    begin
        current_state <= IDLE ;
    end
    else
    begin
        current_state <= next_state ;
    end
end


//next state logic
always @ (*)
begin
    error_count = error_count_reg;

    case (current_state)
    IDLE : begin
        error_count = 'b0;
        if(pass_en)
        begin
            next_state = LANGUAGE ;
        end
        else
        begin
            next_state = IDLE ;
        end
    end

    LANGUAGE : begin
        if(time_out || cancel_button) // if threshold time has passed, the operation will be canceled (back to idle)
        begin
            next_state = IDLE ;
        end
        else
        begin
            if(language == 2'b01 || language == 2'b10)
            begin
                next_state = WRITE_PASS ;
            end
            else
            begin
                next_state = LANGUAGE ;
            end
        end
        
    end

    WRITE_PASS : begin
        error_count = error_count_reg;
        if(time_out || cancel_button)
        begin
            next_state = IDLE ;
        end
        else if(enter_button)
        begin
            next_state = CHECK_PASS ;
        end
        else
        begin
            next_state = WRITE_PASS ;
        end
    end

    CHECK_PASS : begin
        if(wrong_password) // el mafrod b3d 3 mrat wrong atl3o bara (idle) 
        begin
            if(error_count_reg == 2'b10)
            begin
                error_count = 2'b0;
                next_state = IDLE ;
            end
            else
            begin
                error_count = error_count_reg + 'b1 ;
                next_state = WRITE_PASS ;
            end    
        end
        else
        begin
            error_count = 2'b0;
            next_state = OPERATION ;
        end
    end

    OPERATION : begin
        if(time_out || cancel_button) // if threshold time has passed, the operation will be canceled (back to idle)
        begin
            next_state = IDLE ;
        end
        else
        begin
            if(operation == 2'b00)
            begin
                next_state = WRITE_WITHDRAW ;
            end
            else if(operation == 2'b01)
            begin
                next_state = WRITE_DEPOSIT ;
            end
            else if(operation == 2'b10)
            begin
                next_state = BALANCE ;
            end
            else
            begin
                next_state = OPERATION ;
            end
        end
    end

    WRITE_WITHDRAW : begin
         error_count = error_count_reg;
        if(time_out || cancel_button)
        begin
            next_state = IDLE ;
        end
        else
        begin
            if(enter_button)
            begin
                next_state = WITHDRAW ;
            end
            else 
            begin
                next_state = WRITE_WITHDRAW ;
            end
        end
    end

    WITHDRAW : begin
        if(operation_done)
        begin
            error_count = 2'b0;
            if(time_out || cancel_button)
            begin
                next_state = IDLE ;
            end
            else
            begin
                if(another_service)
                begin
                    next_state = OPERATION ;
                end
                else
                begin
                    next_state = WITHDRAW ;
                end
            end
        end

        else //if(error)
        begin
            if(error_count_reg == 2'b10)
            begin
                error_count = 2'b0;
                next_state = IDLE ;
            end
            else
            begin
                error_count = error_count_reg + 'b1 ;
                next_state = WRITE_WITHDRAW ;
            end
        end

        // else
        // begin
        //     error_count = 2'b0;
        //     next_state = WITHDRAW ;
        // end
    end

    WRITE_DEPOSIT : begin
         error_count = error_count_reg;
        if(time_out || cancel_button)
        begin
            next_state = IDLE ;
        end
        else
        begin
            if(enter_button)
            begin
                next_state = DEPOSIT ;
            end
            else
            begin
                next_state = WRITE_DEPOSIT ;
            end
        end
    end

    DEPOSIT : begin
        if(operation_done)
        begin
            error_count = 2'b0;

            if(time_out || cancel_button)
            begin
                next_state = IDLE ;
            end
            else
            begin
                if(another_service)
                begin
                    next_state = OPERATION ;
                end
                else
                begin
                    next_state = DEPOSIT ;
                end
            end 
        end

        else //if(error)
        begin
            if(error_count_reg == 2'b10)
            begin
                error_count = 2'b0;
                next_state = IDLE ;
            end
            else
            begin
                error_count = error_count_reg + 'b1 ;
                next_state = WRITE_DEPOSIT ;
            end
        end

        // else
        // begin
        //     next_state = DEPOSIT ;
        //     error_count = 2'b0;
        // end
    end

    BALANCE : begin
        if(time_out || cancel_button)
        begin
            next_state = IDLE ;
        end
        else
        begin
            if(another_service)
            begin
                next_state = OPERATION ;
            end
            else
            begin
                next_state = BALANCE ;
            end
        end
        
    end
    endcase
end


//output logic
always @ (*)
begin

    //waiting_op = 1'b0 ;       // default value

    case (current_state)
    IDLE : begin
        wrong_password = 1'b0 ;
        operation_done = 1'b0 ;
        error = 1'b0 ;
        updated_balance_comb = updated_balance ; 
        start_timer = 1'b0 ;
        card_out = 1'b0 ;
    end

    LANGUAGE : begin
        wrong_password = 1'b0 ;
        operation_done = 1'b0 ;
        error = 1'b0 ;
        updated_balance_comb = updated_balance ; 

        start_timer = 1'b1 ;

        if(time_out || cancel_button) 
        begin
            card_out = 1'b1 ;
        end
        else
        begin
            card_out = 1'b0 ;
        end  
    end

    WRITE_PASS : begin
        wrong_password = 1'b0 ;
        operation_done = 1'b0 ;
        error = 1'b0 ;
        updated_balance_comb = updated_balance ; 
        start_timer = 1'b1 ;

        if(time_out || cancel_button) 
        begin
            card_out = 1'b1 ;
        end
        else
        begin
            card_out = 1'b0 ;
        end  
    end

    CHECK_PASS : begin
        operation_done = 1'b0 ;
        
        updated_balance_comb = updated_balance ; 
        start_timer = 1'b0 ;
        card_out = 1'b0 ;

        if(in_password == user_password)
        begin
            wrong_password = 1'b0 ;
            error = 1'b0 ;
        end
        else
        begin
            wrong_password = 1'b1 ;
            error = 1'b1 ;
        end
    end

    OPERATION : begin
        wrong_password = 1'b0 ;
        operation_done = 1'b0 ;
        error = 1'b0 ;
        updated_balance_comb = updated_balance ;

        start_timer = 1'b1 ;

        if(time_out || cancel_button) 
        begin
            card_out = 1'b1 ;
        end
        else
        begin
            card_out = 1'b0 ;
        end  
    end

    WRITE_WITHDRAW : begin
        wrong_password = 1'b0 ;
        operation_done = 1'b0 ;
        error = 1'b0 ;
        updated_balance_comb = updated_balance ; 
        start_timer = 1'b1 ;

        if(time_out || cancel_button) 
        begin
            card_out = 1'b1 ;
        end
        else
        begin
            card_out = 1'b0 ;
        end  
    end

    WITHDRAW : begin
        wrong_password = 1'b0 ;
        start_timer = 1'b1 ;

        if(!operation_done) //this condition to prevent running the operation more than one time until transition from this state
        begin
            if(entry_value > current_balance)
            begin
                error = 1'b1 ;
                updated_balance_comb = updated_balance ;
                operation_done = 1'b0 ;
            end
            else
            begin
                error = 1'b0 ;
                updated_balance_comb = updated_balance - entry_value ;
                operation_done = 1'b1 ;
            end
        end
        else
        begin
            error = 1'b0 ;
            updated_balance_comb = updated_balance ;
            operation_done = 1'b1 ;
        end 

        if(time_out || cancel_button) 
        begin
            card_out = 1'b1 ;
        end
        else
        begin
            card_out = 1'b0 ;
        end  
    end

    WRITE_DEPOSIT : begin
        wrong_password = 1'b0 ;
        operation_done = 1'b0 ;
        error = 1'b0 ;
        updated_balance_comb = updated_balance ; 
        start_timer = 1'b1 ;

        if(time_out || cancel_button) 
        begin
            card_out = 1'b1 ;
        end
        else
        begin
            card_out = 1'b0 ;
        end  
    end

    DEPOSIT : begin
        wrong_password = 1'b0 ;
        start_timer = 1'b1 ;

        if(!operation_done) //this condition to prevent running the operation more than one time until transition from this state
        begin
            if(entry_value == actual_deposit_value)
            begin
                error = 1'b0 ;
                updated_balance_comb = updated_balance + actual_deposit_value ;
                operation_done = 1'b1 ;
            end
            else
            begin
                error = 1'b1 ;
                updated_balance_comb = updated_balance ;
                operation_done = 1'b0 ;
            end
        end
        else
        begin
            error = 1'b0 ;
            updated_balance_comb = updated_balance ;
            operation_done = 1'b1 ;
        end

        if(time_out || cancel_button) 
        begin
            card_out = 1'b1 ;
        end
        else
        begin
            card_out = 1'b0 ;
        end   
    end

    BALANCE : begin
        wrong_password = 1'b0 ;
        operation_done = 1'b1 ;
        error = 1'b0 ;
        updated_balance_comb = updated_balance ; 
        start_timer = 1'b1 ;

        if(time_out || cancel_button) 
        begin
            card_out = 1'b1 ;
        end
        else
        begin
            card_out = 1'b0 ;
        end  
    end
    endcase
end



assign restart_timer = another_service || enter_button || (language == 2'b01) || (language == 2'b10) || (operation == 2'b00) || (operation == 2'b01) || (operation == 2'b10);

endmodule