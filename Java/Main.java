import java.util.Random;
import java.util.Scanner;

class Main
{
	public static void main(String[] args)
	{
		Scanner sc = new Scanner(System.in);
		int i = sc.nextInt();
		System.out.println("Hello, World!\n" + i);
	}

	public static void Generator(int i)
	{
		Random r = new Random();
		for (int j = 1; j < i; j++)
		{
			char c = (char)(r.nextInt(95) + 32);
			String s = new String(c, "utf-8");
			System.out.print(s);
		}
	}
}

