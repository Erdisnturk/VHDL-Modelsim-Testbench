------------------------------------------------------------------------------------------
--																
-- Dateiname:	Arithmetische_Logikeinheit.vhd
--
-- Inhalt:	Verhaltensmodell der arithmetischen Logikeinheit (ALU)
--
------------------------------------------------------------------------------------------
										
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

------------------------------------------------------------------------------------------

ENTITY alu IS

	PORT(
		data_in0, data_in1 : IN  std_logic_vector(3 DOWNTO 0); -- 4 Bit Operanden        
      	instruction : IN std_logic_vector(3 DOWNTO 0); 		-- Codierung der auszufuehrende Instruktion
		instruction_en : IN std_logic;
	   	data_out : OUT  std_logic_vector(3 DOWNTO 0); 		-- Datenausgang
      	status_out : OUT std_logic_vector(2 DOWNTO 0)); 		-- Statusflags
		       
END alu;

------------------------------------------------------------------------------------------

ARCHITECTURE behavioral OF alu IS


------------------------------------------------------------------------------------------
  
FUNCTION is_zero (in_zahl : IN integer) RETURN std_logic IS		-- Zero-Flag

	BEGIN
		IF in_zahl = 0 THEN
			RETURN '1';
		ELSE
			RETURN '0';
		END IF;
	END;
		
------------------------------------------------------------------------------------------
	
FUNCTION is_negative (in_zahl : IN integer) RETURN std_logic IS	-- Negative-Flag

	BEGIN
		IF in_zahl < 0 THEN
			RETURN '1';
		ELSE
			RETURN '0';
		END IF;
	END;
		
-------------------------------------------------------------------------------------------
	    
BEGIN

calculation : PROCESS(data_in0, data_in1, instruction, instruction_en)
	
VARIABLE int_result : integer;
VARIABLE result : std_logic_vector(4 DOWNTO 0);
VARIABLE status : std_logic_vector(2 DOWNTO 0);
			     
	BEGIN

	if instruction_en = '1' then
		CASE instruction IS

			WHEN "0000" =>	-- Addition
						int_result := conv_integer(data_in0) + conv_integer(data_in1);
						result := conv_std_logic_vector(int_result, 5);

			WHEN "0001" => -- Subtraktion
						int_result := conv_integer(data_in0) - conv_integer(data_in1);
						result := conv_std_logic_vector(int_result, 5);					    

			WHEN "0010" => -- OR-Funktion
						result(3 downto 0) := data_in0 OR data_in1;
						result(4) := '0';
									   
			WHEN "0011" => -- AND-Funktion
						result(3 downto 0) := data_in0 AND data_in1;
						result(4) := '0';

			WHEN "0100" => -- XOR-Funktion
						result(3 downto 0) := data_in0 XOR data_in1;
						result(4) := '0';

			WHEN "0101" => -- NOT-Funktion
					result(3 downto 0) := NOT data_in0;		
						result(4) := '0';

			WHEN "0110" => -- Shift right	(Division durch 2)
						result(3) := data_in0(2);
						result(2) := data_in0(1);								    
						result(1) := data_in0(0);
						result(0) := data_in0(3);
						result(4) := data_in0(0); -- LSB in Carry

			WHEN "0111" => -- Shift left (Multiplikation mit 2)
						result(3) := data_in0(0);
						result(2) := data_in0(3);
						result(1) := data_in0(2);
						result(0) := data_in0(1);
						result(4) := data_in0(3); -- MSB in Carry

			WHEN OTHERS => NULL; 
																															
		END CASE;

		status(0) := result(4); 				-- Carry-Flag
		status(1) := is_negative(int_result);	-- Negative-Flag (nur ADD & SUB)
		status(2) := NOT (result(0) OR result(1) OR result(2) OR result(3)); -- Zero-Flag
	end if;
	
	status_out <= status;
	data_out <= result(3 downto 0); 

END PROCESS;

---------------------------------------------------------------------------------------------

END behavioral;
