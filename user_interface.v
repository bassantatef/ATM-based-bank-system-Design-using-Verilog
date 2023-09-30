module user_interface #(parameter  	P_WIDTH = 16,
                            		B_WIDTH = 20 )
(
    input wire                      clk,
    input wire                      rst,

	input wire                      card_in,

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
    // input wire                      correct_button,

	// input wire                      touch_100_button,
    // input wire                      touch_300_button,
    // input wire                      touch_500_button,
	// input wire                      touch_700_button,
    // input wire                      touch_1000_button,
	input wire                      multiple_100_button,
    input wire                      multiple_1000_button,

    input wire                      withdraw_button,
    input wire                      deposit_button,
    input wire                      show_balance,

    input wire                      another_service,

    input wire                      English_button,
    input wire                      Arabic_button,


   /*  output reg     [B_WIDTH-1:0]    withdraw_value, //written by user 
    output reg     [B_WIDTH-1:0]    deposit_value, //written by user */ 
	output reg     [B_WIDTH-1:0]    entry_value, //written by user 

    output reg     [P_WIDTH-1:0]    in_password, //written by user 
	output reg     [1:0]            operation,

	output reg     [1:0]	        language

);


reg  [1:0]  count = 2'd0 ; 

reg  [3:0]  temp1, temp2, temp3, temp4 ;

reg     [P_WIDTH-1:0]    in_password_temp;

/* reg     [B_WIDTH-1:0]    withdraw_value_temp;
reg     [B_WIDTH-1:0]    deposit_value_temp; */
reg     [B_WIDTH-1:0]    entry_value_temp;


reg                 withdraw_hold, withdraw_100_hold, withdraw_1000_hold ;

//reg                 write_pass_hold ;

// withdraw --> 00
// deposit  --> 01
// balance  --> 10

always @(posedge clk or negedge rst) 
begin
	if(!rst)
	begin
		in_password     <= 'b0;
		entry_value  <= 'b0;
		//deposit_value   <= 'b0;
		
	end
	else
	begin
		in_password     <= in_password_temp ;
		entry_value     <= entry_value_temp ;
		//deposit_value   <= deposit_value_temp ;
		
	end
end


always @(*) 
begin
	if(withdraw_button || deposit_button)
	begin
		entry_value_temp = entry_value ;
		//deposit_value_temp  = deposit_value ;
		withdraw_hold       = 1'b1; 
		withdraw_100_hold   = 1'b0;
		withdraw_1000_hold  = 1'b0;
	end
	else if(withdraw_hold)
	begin
		// if(touch_100_button)
		// begin
		// 	entry_value_temp = 'd100;
		// 	//deposit_value_temp  = 'd100;
		// 	withdraw_hold       = 1'b0; 
		// 	withdraw_100_hold   = 1'b0;
		// 	withdraw_1000_hold  = 1'b0;
		// end
		// else if(touch_300_button)
		// begin
		// 	entry_value_temp = 'd300;
		// 	//deposit_value_temp  = 'd300;
		// 	withdraw_hold  		= 1'b0; 
		// 	withdraw_100_hold   = 1'b0;
		// 	withdraw_1000_hold  = 1'b0;
		// end
		// else if(touch_500_button)
		// begin
		// 	entry_value_temp = 'd500;
		// 	//deposit_value_temp  = 'd500;
		// 	withdraw_hold  		= 1'b0; 
		// 	withdraw_100_hold   = 1'b0;
		// 	withdraw_1000_hold  = 1'b0;
		// end
		// else if(touch_700_button)
		// begin
		// 	entry_value_temp = 'd700;
		// 	//deposit_value_temp  = 'd700;
		// 	withdraw_hold  		= 1'b0; 
		// 	withdraw_100_hold   = 1'b0;
		// 	withdraw_1000_hold  = 1'b0;
		// end
		// else if(touch_1000_button)
		// begin
		// 	entry_value_temp = 'd1000;
		// 	//deposit_value_temp  = 'd1000;
		// 	withdraw_hold  		= 1'b0; 
		// 	withdraw_100_hold   = 1'b0;
		// 	withdraw_1000_hold  = 1'b0;
		// end
		/*else*/ if(multiple_100_button)
		begin
			entry_value_temp = entry_value ;
			//deposit_value_temp  = deposit_value ;
			withdraw_100_hold   = 1'b1;
			withdraw_hold       = 1'b1;
			withdraw_1000_hold  = 1'b0;
		end
		else if(withdraw_100_hold)
		begin
			if(button_1)
			begin
				entry_value_temp = 'd100;
				//deposit_value_temp  = 'd100;
				withdraw_100_hold   = 1'b0;
				withdraw_hold       = 1'b0;
				withdraw_1000_hold  = 1'b0;
			end
			else if(button_2)
			begin
				entry_value_temp = 'd200 ;
				//deposit_value_temp  = 'd200;
				withdraw_100_hold   = 1'b0;
				withdraw_hold       = 1'b0;
				withdraw_1000_hold  = 1'b0;
			end
			else if(button_3)
			begin
				entry_value_temp = 'd300 ;
				//deposit_value_temp  = 'd300;
				withdraw_100_hold   = 1'b0;
				withdraw_hold       = 1'b0;
				withdraw_1000_hold  = 1'b0;
			end
			else if(button_4)
			begin
				entry_value_temp = 'd400 ;
				//deposit_value_temp  = 'd400;
				withdraw_100_hold   = 1'b0;
				withdraw_hold       = 1'b0;
				withdraw_1000_hold  = 1'b0;
			end
			else if(button_5)
			begin
				entry_value_temp      = 'd500 ;
				//deposit_value_temp  = 'd500;
				withdraw_100_hold   = 1'b0;
				withdraw_hold       = 1'b0;
				withdraw_1000_hold  = 1'b0;
			end
			else if(button_6)
			begin
				entry_value_temp      = 'd600 ;
				//deposit_value_temp  = 'd600;
				withdraw_100_hold   = 1'b0;
				withdraw_hold       = 1'b0;
				withdraw_1000_hold  = 1'b0;
			end
			else if(button_7)
			begin
				entry_value_temp      = 'd700 ;
				//deposit_value_temp  = 'd700;
				withdraw_100_hold   = 1'b0;
				withdraw_hold       = 1'b0;
				withdraw_1000_hold  = 1'b0;
			end
			else if(button_8)
			begin
				entry_value_temp      = 'd800 ;
				//deposit_value_temp  = 'd800;
				withdraw_100_hold   = 1'b0;
				withdraw_hold       = 1'b0;
				withdraw_1000_hold  = 1'b0;
			end
			else if(button_9)
			begin
				entry_value_temp      = 'd900 ;
				//deposit_value_temp  = 'd800;
				withdraw_100_hold   = 1'b0;
				withdraw_hold       = 1'b0;
				withdraw_1000_hold  = 1'b0;
			end
			else
			begin
				entry_value_temp = entry_value ;
				//deposit_value_temp  = deposit_value;
				withdraw_100_hold   = 1'b1;
				withdraw_hold       = 1'b1;
				withdraw_1000_hold  = 1'b0;
			end
		end
		else if(multiple_1000_button)
		begin
			entry_value_temp = entry_value ;
			//deposit_value_temp  = deposit_value;
			withdraw_hold      = 1'b1;
			withdraw_100_hold  = 1'b0;
			withdraw_1000_hold = 1'b1;
		end
		else if(withdraw_1000_hold)
		begin
			if(button_1)
			begin
				entry_value_temp = 'd1000 ;
				//deposit_value_temp  = 'd1000;
				withdraw_hold      = 1'b0;
				withdraw_100_hold  = 1'b0;
				withdraw_1000_hold = 1'b0;
			end
			else if(button_2)
			begin
				entry_value_temp = 'd2000 ;
				//deposit_value_temp  = 'd2000;
				withdraw_hold      = 1'b0;
				withdraw_100_hold  = 1'b0;
				withdraw_1000_hold = 1'b0;
			end
			else if(button_3)
			begin
				entry_value_temp = 'd3000 ;
				//deposit_value_temp  = 'd3000;
				withdraw_hold      = 1'b0;
				withdraw_100_hold  = 1'b0;
				withdraw_1000_hold = 1'b0;
			end
			else if(button_4)
			begin
				entry_value_temp = 'd4000 ;
				//deposit_value_temp  = 'd4000;
				withdraw_hold      = 1'b0;
				withdraw_100_hold  = 1'b0;
				withdraw_1000_hold = 1'b0;
			end
			else if(button_5)
			begin
				entry_value_temp = 'd5000 ;
				//deposit_value_temp  = 'd5000;
				withdraw_hold      = 1'b0;
				withdraw_100_hold  = 1'b0;
				withdraw_1000_hold = 1'b0;
			end
			else if(button_6)
			begin
				entry_value_temp = 'd6000 ;
				//deposit_value_temp  = 'd6000;
				withdraw_hold      = 1'b0;
				withdraw_100_hold  = 1'b0;
				withdraw_1000_hold = 1'b0;
			end
			else if(button_7)
			begin
				entry_value_temp = 'd7000 ;
				//deposit_value_temp  = 'd7000;
				withdraw_hold      = 1'b0;
				withdraw_100_hold  = 1'b0;
				withdraw_1000_hold = 1'b0;
			end
			else if(button_8)
			begin
				entry_value_temp = 'd8000 ;
				//deposit_value_temp  = 'd8000;
				withdraw_hold      = 1'b0;
				withdraw_100_hold  = 1'b0;
				withdraw_1000_hold = 1'b0;
			end
			else if(button_9)
			begin
				entry_value_temp = 'd9000 ;
				//deposit_value_temp  = 'd9000;
				withdraw_hold      = 1'b0;
				withdraw_100_hold  = 1'b0;
				withdraw_1000_hold = 1'b0;
			end
			else
			begin
				entry_value_temp = entry_value ;
				//deposit_value_temp  = deposit_value;
				withdraw_hold      = 1'b1;
				withdraw_100_hold  = 1'b0;
				withdraw_1000_hold = 1'b1;
			end
		end 
	end
	else
	begin
		entry_value_temp = entry_value ;
		//deposit_value_temp  = deposit_value;
		withdraw_hold      = 1'b0;
		withdraw_100_hold  = 1'b0;
		withdraw_1000_hold = 1'b0;
	end
end



always @(*) 
begin
	if(withdraw_button)
	begin
		operation = 2'b00 ;
	end
	else if(deposit_button)
	begin
		operation = 2'b01 ;
	end
	else if(show_balance)
	begin
		operation = 2'b10 ;
	end
	else
	begin
		operation = 2'b11 ; //default value
	end
end



always @(posedge clk or negedge rst) 
begin
    if(!rst)
    begin
        count <= 'b0;
		temp1 <= 'd0;
		temp2 <= 'd0;
		temp3 <= 'd0;
		temp4 <= 'd0;
    end
    else if(card_in)
	begin
		count <= 'b0 ;
	end
	else
    begin
        if(button_0)
        begin
		  if(count == 'd0)
		  begin
		   temp1 <= 'd0;
		   count <= count + 1'b1 ;
		  end
		  else if(count == 'd1)
		  begin
		   temp2 <= 'd0;
		   count <= count + 1'b1 ;
		  end
		  else if(count == 'd2)
		  begin
		   temp3 <= 'd0;
		   count <= count + 1'b1 ;
		  end
		  else
		  begin
		   temp4 <= 'd0;
		   count <= 1'b0 ;
		  end
            
        end
        else if (button_1) 
        begin
		  if(count == 'd0)
		  begin
		   temp1 <= 'd1;
		   count <= count + 1'b1 ;
		  end
		  else if(count == 'd1)
		  begin
		   temp2 <= 'd1;
		   count <= count + 1'b1 ;
		  end
		  
		  else if(count == 'd2)
		  begin
		   temp3 <= 'd1;
		   count <= count + 1'b1 ;
		  end
		  
		  else
		  begin
		   temp4 <= 'd1;
		   count <= 1'b0 ;
		  end
            
        end
        else if (button_2) 
        begin
		
		 if(count == 'd0)
		  begin
		   temp1 <= 'd2;
		   count <= count + 1'b1 ;
		  end
		  else if(count == 'd1)
		  begin
		   temp2 <= 'd2;
		   count <= count + 1'b1 ;
		  end
		  
		  else if(count == 'd2)
		  begin
		   temp3 <= 'd2;
		   count <= count + 1'b1 ;
		  end
		  
		  else
		  begin
		   temp4 <= 'd2;
		   count <= 1'b0 ;
		  end
            
        end
        else if (button_3) 
        begin
		 if(count == 'd0)
		  begin
		   temp1 <= 'd3;
		   count <= count + 1'b1 ;
		  end
		  else if(count == 'd1)
		  begin
		   temp2 <= 'd3;
		   count <= count + 1'b1 ;
		  end
		  
		  else if(count == 'd2)
		  begin
		   temp3 <= 'd3;
		   count <= count + 1'b1 ;
		  end
		  
		  else
		  begin
		   temp4 <= 'd3;
		   count <= 1'b0 ;
		  end
            
        end
        else if (button_4) 
        begin
		
		  if(count == 'd0)
		  begin
		   temp1 <= 'd4;
		   count <= count + 1'b1 ;
		  end
		  else if(count == 'd1)
		  begin
		   temp2 <= 'd4;
		   count <= count + 1'b1 ;
		  end
		  else if(count == 'd2)
		  begin
		   temp3 <= 'd4;
		   count <= count + 1'b1 ;
		  end
		  else
		  begin
		   temp4 <= 'd4;
		   count <= 1'b0 ;
		  end
            
        end
        else if (button_5) 
        begin
           if(count == 'd0)
		  begin
		   temp1 <= 'd5;
		   count <= count + 1'b1 ;
		  end
		  else if(count == 'd1)
		  begin
		   temp2 <= 'd5;
		   count <= count + 1'b1 ;
		  end
		  else if(count == 'd2)
		  begin
		   temp3 <= 'd5;
		   count <= count + 1'b1 ;
		  end
		  else
		  begin
		   temp4 <= 'd5;
		   count <= 1'b0 ;
		  end 
        end
        else if (button_6) 
        begin
		 if(count == 'd0)
		  begin
		   temp1 <= 'd6;
		   count <= count + 1'b1 ;
		  end
		  else if(count == 'd1)
		  begin
		   temp2 <= 'd6;
		   count <= count + 1'b1 ;
		  end
		  else if(count == 'd2)
		  begin
		   temp3 <= 'd6;
		   count <= count + 1'b1 ;
		  end
		  else
		  begin
		   temp4 <= 'd6;
		   count <= 1'b0 ;
		  end 
            
        end
        else if (button_7) 
        begin
            if(count == 'd0)
		  begin
		   temp1 <= 'd7;
		   count <= count + 1'b1 ;
		  end
		  else if(count == 'd1)
		  begin
		   temp2 <= 'd7;
		   count <= count + 1'b1 ;
		  end
		  else if(count == 'd2)
		  begin
		   temp3 <= 'd7;
		   count <= count + 1'b1 ;
		  end
		  else
		  begin
		   temp4 <= 'd7;
		   count <= 1'b0 ;
		  end 
        end
        else if (button_8) 
        begin
            if(count == 'd0)
		  begin
		   temp1 <= 'd8;
		   count <= count + 1'b1 ;
		  end
		  else if(count == 'd1)
		  begin
		   temp2 <= 'd8;
		   count <= count + 1'b1 ;
		  end
		  else if(count == 'd2)
		  begin
		   temp3 <= 'd8;
		   count <= count + 1'b1 ;
		  end
		  else
		  begin
		   temp4 <= 'd8;
		   count <= 1'b0 ;
		  end 
        end
        else if (button_9) 
        begin
            if(count == 'd0)
		  begin
		   temp1 <= 'd9;
		   count <= count + 1'b1 ;
		  end
		  else if(count == 'd1)
		  begin
		   temp2 <= 'd9;
		   count <= count + 1'b1 ;
		  end
		  else if(count == 'd2)
		  begin
		   temp3 <= 'd9;
		   count <= count + 1'b1 ;
		  end
		  else
		  begin
		   temp4 <= 'd9;
		   count <= 1'b0 ;
		  end 
        end
    end
end


always @(*) begin
    if(enter_button ) 
	begin
		in_password_temp = {temp1, temp2, temp3, temp4} ;
		
	end
	else
	begin
		in_password_temp = in_password ;
		
	end
end

always @(*) 
begin
	if(English_button)
	begin
		language = 2'b01;
	end	
	else if(Arabic_button)
	begin
		language = 2'b10;
	end
	else
	begin
		language = 2'b00;  // default value
	end
end

endmodule