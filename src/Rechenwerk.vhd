------------------------------------------------------------------------------------------------
--							
-- Dateiname:	Rechenwerk.vhd
--
-- Inhalt: 	structural description of arithmetic unit
--                   
--
------------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

------------------------------------------------------------------------------------------------

ENTITY data_path_struct IS

	PORT(
		clk   			: in std_logic;						    	-- clock
		rst 			: in std_logic;						    	-- Reset, high active
		mux_sel_sig 	: in std_logic;								-- control signal of Mux above Register R1
		R1_en 			: in std_logic;				    			-- R1 enable-Signal
		R2_en 			: in std_logic;								-- R2 enable-Signal
		instruction 	: in std_logic_vector(3 DOWNTO 0);  		--  control signals for the ALU
		instruction_en 	: in std_logic;
		mux_R2_data_in 	: in std_logic_vector(3 DOWNTO 0); 			-- Input 1 of Mux and R2
		status_out 		: out std_logic_vector(2 DOWNTO 0);			-- output Status register
		alu_res 		: out std_logic_vector(3 DOWNTO 0);    		-- output ALU 
		alu_res_rdy 	: out std_logic);

END data_path_struct;

------------------------------------------------------------------------------------------------

ARCHITECTURE structural OF data_path_struct IS

SIGNAL mux_out : std_logic_vector(3 DOWNTO 0); 		-- output Mux
SIGNAL R1_out : std_logic_vector(3 DOWNTO 0);  		-- output Registers R1
SIGNAL R2_out : std_logic_vector(3 DOWNTO 0);  		-- output Registers R2
SIGNAL alu_out : std_logic_vector(3 DOWNTO 0); 		-- output ALU
SIGNAL alu_status_out : std_logic_vector(2 DOWNTO 0); 	-- Status-output ALU

SIGNAL h_level : std_logic;						-- H-level

signal result_rdy : std_logic;

------------------------------------------------------------------------------------------------

	COMPONENT alu IS
		
		PORT(
			data_in0, data_in1 : IN  std_logic_vector(3 DOWNTO 0);        
	      	instruction : IN std_logic_vector(3 DOWNTO 0);
			instruction_en : IN std_logic;
		   	data_out : OUT  std_logic_vector(3 DOWNTO 0); 
	      	status_out : OUT std_logic_vector(2 DOWNTO 0)); 
			
	END COMPONENT;

	COMPONENT reg IS

		GENERIC(
			word_length : integer); 

		PORT(
			clk : IN std_logic; 
			rst 			: in std_logic;		
			en : IN std_logic; 			
	   		data_in : in std_logic_vector(word_length - 1 DOWNTO 0);
		   	data_out : OUT std_logic_vector(word_length - 1 DOWNTO 0)); 

	END COMPONENT;

	COMPONENT mux IS

		GENERIC(
			word_length : integer); 	

		PORT(
	   		in_vec1 : IN std_logic_vector(word_length - 1 DOWNTO 0);
			in_vec0 : IN std_logic_vector(word_length - 1 DOWNTO 0);
		   	sel_sig : IN std_logic;
		   	out_vec : OUT std_logic_vector(word_length - 1 DOWNTO 0));		

	END COMPONENT;

-------------------------------------------------------------------------------------------------

BEGIN

	h_level <= '1';
	
	process (rst, clk)
	begin
		if rst = '1' then
			alu_res_rdy <= '0';
		elsif rising_edge(clk) then
			alu_res_rdy <= instruction_en;
		end if;
	end process;
-------------------------------------------------------------------------------------------------

	alu_instance : alu 						
		PORT MAP(
				data_in0 		=> R1_out, 					
				data_in1 		=> R2_out,					
		      	instruction 	=> instruction,		
				instruction_en 	=> instruction_en,
			   	data_out 		=> alu_out,						
		      	status_out		=> alu_status_out);				
			
	R1_inst : reg
		GENERIC MAP(
   				word_length => 4) 

		PORT MAP(
				clk 		=> clk,
				rst			=> rst,
			   	en 			=> R1_en,
		        data_in 	=> mux_out,
			   	data_out 	=> R1_out);
 
	R2_inst : reg
		GENERIC MAP(
   				word_length => 4) 

		PORT MAP(
				clk 		=> clk,
				rst			=> rst,
				en	 		=> R2_en,
		   		data_in 	=> mux_R2_data_in,
			   	data_out 	=> R2_out);

	Status_inst : reg
		GENERIC MAP(
				word_length => 3)

		PORT MAP(
				clk 		=> clk,
				en 			=> h_level,
				rst			=> rst,
				data_in 	=> alu_status_out,
				data_out 	=> status_out);  
	
	Alu_res_reg_inst : reg
		GENERIC MAP(
   				word_length => 4) 

		PORT MAP(
				clk 		=> clk,
				rst			=> rst,
			   	en 			=> R1_en,
		        data_in 	=> alu_out,
			   	data_out 	=> alu_res);
 
	mux_inst : mux
		GENERIC MAP(
   				word_length => 4) 

		PORT MAP(
				in_vec0 => alu_out,
				in_vec1 => mux_R2_data_in, 

			   	sel_sig => mux_sel_sig,
			   	out_vec => mux_out);		

--------------------------------------------------------------------------------------------------

END structural;
