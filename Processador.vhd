 library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity Processador is
port(
		entradas : in std_logic_vector(9 downto 0);
		clock   	: in std_logic;
		display1 : out std_logic_vector(6 downto 0);
		display2 : out std_logic_vector(6 downto 0);
		display3 : out std_logic_vector(6 downto 0);
		display4 : out std_logic_vector(6 downto 0)
		);
end Processador;

architecture hardware of Processador is

	signal operacao 	: std_logic_vector(4 downto 0);		-- sinal para as operações

	signal valor1		: 	std_logic_vector(9 downto 0);     -- sinal usado como primeiro valor
	signal valor2		: 	std_logic_vector(9 downto 0);     -- sinal usado como segundo valor
	signal fat			: 	std_logic_vector(9 downto 0);		-- sinal usado para o fatorial
	signal saida1		: 	std_logic_vector(9 downto 0);     -- sinal usado como saida das operações aritméticas
	signal saida2		: 	boolean;                          -- sinal usado como saida das operações lógicas
	signal reg1 		: 	std_logic_vector(9 downto 0);     -- sinal usado para o registrador 1
	signal reg2 		: 	std_logic_vector(9 downto 0);		-- sinal usado para o registrador 2
	
	signal endereco	: 	std_logic_vector(4 downto 0);     -- Endereço da RAM
	signal add_ram	 	: 	std_logic_vector(9 downto 0);   	-- Dado a ser escrito na RAM
	signal hab_ram		: 	std_logic;                      	-- Habilitar escrita
	signal sai_ram		: 	std_logic_vector(9 downto 0);  	-- Dado lido na RAM
	
	type array_ram is array (0 to 15) of std_logic_vector(9 downto 0);
	signal ram: array_ram :=(
	"0000000000","0000100001","0000100010","0000100011", 	--  0 |  1 | 2  | 3
	"0011000010","0001000101","0001000110","0001000111", 	--  4 |  5 | 6  | 7
	"0100101000","0010101001","1000101010","0001101011", 	--  8 |  9 | 10 | 11
	"0000101100","0000101101","0000101110","0000100100"   -- 12 | 13 | 14 | 15
	); 
	
begin

process(clock)
	begin

	if(clock = '0') then 		
		if(hab_ram = '1') then 	
		ram(to_integer(unsigned(endereco))) <= add_ram; 
		end if;
	end if;
	
end process;

process(entradas)
begin		
			endereco <= entradas(4 downto 0); 
			operacao <= entradas(9 downto 5);											
			sai_ram <= ram(to_integer(unsigned(endereco)));  																			 
			valor1 <= ('0' & '0' & '0' & '0' & '0' & sai_ram(9 downto 5));	
			valor2 <= ('0' & '0' & '0' & '0' & '0' & sai_ram(4 downto 0));	

end process;

process(clock)
begin
	
	if(clock = '0') then 
		
		case operacao is
		
			when "00000" => saida1 <= valor1 + valor2; 	-- soma
			when "00001" => saida1 <= valor1 - valor2; 	-- subtração
			when "00010" => saida1 <= std_logic_vector(to_unsigned(to_integer(unsigned(valor1)) * to_integer(unsigned(valor2)), 10)); -- multiplicação											
			when "00011" => saida1 <= std_logic_vector(to_unsigned(to_integer(unsigned(valor1)) / to_integer(unsigned(valor2)), 10)); -- divisão
			when "00100" => saida2 <= valor1 > valor2;  	-- valor1 maior que valor2
			when "00101" => saida2 <= valor1 < valor2;  	-- valor1 menor que valor2
			when "00110" => saida2 <= valor1 = valor2;  	-- valor1 igual valor2            
			when "00111" => saida2 <= valor1 >= valor2; 	-- vamor1 maior ou igual valor2            
			when "01000" => saida2 <= valor1 <= valor2; 	-- valor1 menor ou igual valor2
			when "01001" => saida2 <= valor1 /= valor2; 	-- valor1 diferente de valor2
			when "10100" => saida1 <= fat;					-- fatorial do primeiro valor da RAM
			when "01010" => reg1 <= sai_ram; 				-- operacao load reg1
			when "01011" => reg2 <= sai_ram; 		 		-- operacao load reg2
			when "10001" => reg2 <= reg1;						-- operacao move reg1 para reg2
			when "10010" => reg2 <= reg2;						-- operacao move reg2 para reg1
			when "10000" => add_ram <= reg1;  				-- operacao store do registrador valor1
			when "11000" => add_ram <= reg2;  				-- operacao store do registrador valor2										
			
			when others => saida1 <= "1111111111"; 		  

	    end case;

	end if;
	
end process;

process(clock)
begin
	
	if (operacao = "10000" or operacao = "11000") then
		
		hab_ram <= '1';
		
	else
		
		hab_ram <= '0';
		
	end if;

end process;

process(clock)
begin	
	
		case(operacao) is
		
				when "00000" => display4 <= "0001000";		-- 'A' soma
									 display3 <= "0100001"; 	-- 'd' soma
			
				when "00001" => display4 <= "0010010"; 	-- 's' subtração
									 display3 <= "1000001"; 	-- 'u' subtração
				
				when "00010" => display4<=  "1001000";		-- 'U' multiplicação
									 display3<=  "1001000";		-- 'U' multiplicação

				when "00011" => display4 <= "0100001"; 	-- 'd' divisão.
									 display3 <= "1001111"; 	-- 'i' divisão.
				
				when "00100" => display4 <= "0111100";  	-- '>' A maior que B.
									 display3 <= "0111100";  	-- '>' A maior que B.
				
				when "00101" => display4 <= "0011110";  	-- '<'A menor que B.
									 display3 <= "0011110";  	-- '<'A menor que B.
				
				when "00110" => display4 <= "0111110";  	-- '=' A igual B.            
									 display3 <= "0111110";  	-- '=' A igual B.            
				
				when "00111" => display4 <= "0111100"; 	-- '>'A maior ou igualB.
									 display3 <= "0111110"; 	-- '='A maior ou igualB.           
				
				when "01000" => display4 <= "0011110"; 	-- '<'A menor ou igualB.
									 display3 <= "0111110"; 	-- '=' A menor ou igualB.
				
				when "01001" => display4 <= "0101101"; 	-- '/' A diferente de B.
									 display3 <= "0101101"; 	-- '/' A diferente de B.
				
				when "01010" => display4 <= "1000111"; 	-- 'L' operacao load reg1
									 display3 <= "1111001"; 	-- '1' operacao load reg1
				
				when "01011" => display4 <= "1000111"; 	-- 'L' operacao load reg2
									 display3 <= "0100100"; 	-- '2' operacao load reg2
									
				when "10100" => display4 <= "0001110"; 	-- 'F' operacao fat1
									 display3 <= "1001110"; 	-- 'T' operacao fat1
									
				when "10001" => display4 <= "0101011"; 	-- 'n' operacao move reg1 para reg2
									 display3 <= "1111001";		-- '1' operacao move reg1 para reg2				
				
				when "10010" => display4 <= "0101011"; 	-- 'n' operacao move reg1 para reg2
									 display3 <= "0100100";		--	'1' operacao move reg1 para reg2					
				
				when "10000" => display4 <= "0010010"; 	-- 'S' operacao store do reg1
									 display3 <= "0001000";  	-- 'A' operacao store do reg1
				
				when "11000" => display4 <= "0010010";  	-- 'S' operacao store do reg2	
									 display3 <= "0000011";  	-- 'b' operacao store do reg2	
									
				when "11111" => display4 <= "0101111";		-- 'r' reset resultado
									 display3 <= "0101111";		-- 'r' reset resultado
									
				when others => display4	<="1111111" ; 		-- desligar display
									display3 <="1111111" ;  	-- desligar display
									
		end case;

end process;

process(clock)

begin

	if (clock = '1') then
		
		if (operacao = "10100") then
            integer i;
            fat := std_logic_vector(to_unsigned(1, 8));
            for i in 1 to reg1 loop
                fat := std_logic_vector(to_unsigned(to_integer(unsigned(fat)) * i, 10));
            end loop;
            saida1 <= fat;
		end if; 
	
	end if;
	
end process;


process(clock)
begin
	
	if (operacao = "00100" or operacao = "01001" or operacao = "00110" or operacao = "00111" or operacao = "01000" or operacao = "01001") then
		
		case saida2 is 
		
			when false =>  display1 <= "0001110";	-- F quando falso
								display2 <= "1111111";	-- desligar display2 
			when true  =>  display1 <= "1001110";	-- T quando verdadeiro
								display2 <= "1111111";	-- desligar display2 
	
		end case;
		
	end if;

	if (clock = '1') then
	
		case (saida1(4 downto 0)) is      					
		
			when "00000" => display1 <= "1000000"; 	--'0'
										display2 <= "1111111";	-- desligar display2 
										
			when "00001" => display1 <= "1111001"; 	--'1'
										display2 <= "1111111";	-- desligar display2 
										
			when "00010" => display1 <= "0100100"; 	--'2'
										display2 <= "1111111";	-- desligar display2
										
			when "00011" => display1 <= "0110000"; 	--'3'
										display2 <= "1111111";	-- desligar display2
								
			when "00100" => display1 <= "0011001"; 	--'4'
										display2 <= "1111111"; 	-- desligar display2
									
			when "00101" => display1 <= "0010010"; 	--'5'
										display2 <= "1111111"; 	-- desligar display2
									
			when "00110" => display1 <= "0000010"; 	--'6'
										display2 <= "1111111"; 	-- desligar display2
										
			when "00111" => display1 <= "1111000"; 	--'7'
										display2 <= "1111111"; 	-- desligar display2
										
			when "01000" => display1 <= "0000000"; 	--'8'
										display2 <= "1111111"; 	-- desligar display2
										
			when "01001" => display1 <= "0011000"; 	--'9'
										display2 <= "1111111"; 	-- desligar display2
										
			when "01010" => display2 <= "1111001"; 	--'1'
										display1 <= "1000000"; 	--'0'
										
			when "01011" => display2 <= "1111001"; 	--'1'
										display1 <= "1111001"; 	--'1'
									
			when "01100" => display2 <= "1111001"; 	--'1'
										display1 <= "0100100"; 	--'2'
										
			when "01101" => display2 <= "1111001"; 	--'1'
										display1 <= "0110000"; 	--'3'						
			
			when "01110" => display2 <= "1111001"; 	--'1' 
										display1 <= "0011001"; 	--'4'

			When "01111" => display2 <= "1111001"; 	--'1'
										display1 <= "0010010"; 	--'5'
										
			when "10000" => display2 <= "1111001"; 	--'1' 
										display1 <= "0000010"; 	--'6'
							
			when "10001" => display2 <= "1111001"; 	--'1' 
										display1 <= "1111000"; 	--'7'
										
			when "10010" => display2 <= "1111001"; 	--'1' 
										display1 <= "0000000"; 	--'8'
									
			when "10011" => display2 <= "1111001"; 	--'1' 
										display1 <= "0011000"; 	--'9'
																				
			when "10100" => display2 <= "0100100"; 	--'2' 
										display1 <= "1000000"; 	--'0'
										
			when "10101" => display2 <= "0100100"; 	--'2' 
										display1 <= "1111001"; 	--'1'
																					
			when "10110" => display2 <= "0100100"; 	--'2' 
										display1 <= "0100100"; 	--'2' 
										
			when "10111" => display2 <= "0100100"; 	--'2' 
										display1 <= "0110000"; 	--'3'
										
			when "11000" => display2 <= "0100100"; 	--'2' 
										display1 <= "0011001"; 	--'4'
														
			when "11001" => display2 <= "0100100"; 	--'2' 
										display1 <= "0010010"; 	--'5'
										
			when "11010" => display2 <= "0100100"; 	--'2' 
										display1 <= "0000010"; 	--'6'
										
			when "11011" => display2 <= "0100100"; 	--'2' 
										display1 <= "1111000"; 	--'7'
			
			when "11100" => display2 <= "0100100"; 	--'2' 
										display1 <= "0000000"; 	--'8'
			
			when "11101" => display2 <= "0100100"; 	--'2' 
										display1 <= "0011000"; 	--'9'
			
			when "11110" => display2 <= "0110000"; 	--'3' 
										display1 <= "1000000"; 	--'0'
										
			when "11111" => display2 <= "0110000"; 	--'3' 
								        display1 <= "1111001"; 	--'1'
			
			when others => display1 <= "1111111";
								display2 <= "1111111";
		
		end case;
		
	end if;
		
end process; 

end hardware;

		
