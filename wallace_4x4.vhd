library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
entity wallace_4x4 is 
port(
      A_in : in std_logic_vector(3 downto 0 );
	  B_in : in std_logic_vector(3 downto 0 );
	  -- Output :
	  result : out std_logic_vector(7 downto 0 )
	  );
end entity;
architecture arch of wallace_4x4 is
--Half adder component:
 component half_adder is 
     port(
	 a: in std_logic;
	 b: in std_logic;
	 --Outputs:
	 sum: out std_logic;
	 carry: out std_logic
	 );
 end component;
 --Full adder component :
 component full_adder is 
     port(
	 a: in std_logic;
	 b: in std_logic;
	 c : in std_logic;
	 --Outputs:
	 sum: out std_logic;
	 carry: out std_logic
	 );
 end component;
 -- 	process signal;
 signal p0 : std_logic_vector (3 downto 0);
 signal p1 : std_logic_vector (3 downto 0);
 signal	p2 : std_logic_vector (3 downto 0);
 signal	p3 : std_logic_vector (3 downto 0);
		
		--component ınternal signals :
		signal s11, s12, s13 ,s14, s15 ,s21 , s22, s23 ,s24 ,s25 :std_logic;
		signal c11, c12, c13, c14, c15, c21, c22, c23, c24, c25 : std_logic;
        --final line :
		signal adder_line1: std_logic_vector(7 downto 0 );
		signal adder_line2 : std_logic_vector(7 downto 0 );
		begin
		--Product of Partials  Generation :
		process(A_in, B_in)
		begin 
		for i in 0 to 3 loop
		p0(i) <= A_in(i) and B_in(0);
		p1(i) <= A_in(i) and B_in(1);
		p2(i) <= A_in(i) and B_in(2);
		p3(i) <= A_in(i) and B_in(3);
		end loop;
		end process;
        -- First step :
		ha1 : half_adder port map ( a => p0(0), b => p1(0), sum =>s11, carry => c11);
		fa1 : full_adder port map (a => p0(2), b => p1(1), c => p2(0), sum => s12, carry =>c12);
		fa2 : full_adder port map (a => p0(3), b => p1(2), c => p2(1), sum => s13, carry =>c13);
		fa3 : full_adder port map (a => p1(3), b => p2(2), c => p3(1), sum => s14, carry =>c14);
		ha2 : half_adder port map ( a => p2(3), b => p3(2), sum =>s15, carry => c15);
		
		--Second step : 
		ha3 : half_adder port map ( a => s12, b => c11, sum =>s21, carry => c21);
		fa4 : full_adder port map (a => s13, b => p3(0), c => c12, sum => s22, carry =>c22);
		ha5 : half_adder port map ( a => s14, b => c13, sum =>s23, carry => c23);
		ha6 : half_adder port map ( a => s15, b => c14, sum =>s24, carry => c24);
		ha7 : half_adder port map ( a => p3(3), b => c15, sum =>s25, carry => c25);
		--Asing Final Lines:
		adder_line1(0) <= p0(0);
		adder_line1(1) <= s11;
		adder_line1(2) <= s21;
		adder_line1(3) <= s22;
		adder_line1(4) <= s23;
		adder_line1(5) <= s24;
		adder_line1(6) <= s25;
		adder_line1(7) <= c25;
		--2:
		adder_line2(0) <= '0';
		adder_line2(1) <= '0';
		adder_line2(2) <= '0';
		adder_line2(3) <= c21;
		adder_line2(4) <= c22;
		adder_line2(5) <= c23;
		adder_line2(6) <= c24;
		adder_line2(7) <= '0';
		--Final Addition:
		result <= adder_line1 + adder_line2;
end architecture;	  
	  