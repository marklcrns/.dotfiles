using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;


namespace RobvanderWoude
{
	class ConsoleState
	{
		static string progver = "2.00";


		#region Global Variables

		static bool debugmode = false;
		static bool hidewindow = false;
		static bool showwindow = false;
		static bool activatewindow = true;
		static bool maximizewindow = false;
		static bool minimizewindow = false;
		static bool normalwindow = false;

		#endregion Global Variables


		static int Main( string[] args )
		{
			#region Parse Command Line

			if ( args.Length == 0 )
			{
				if ( IsIconic( GetConsoleWindow( ) ) )
				{
					return 1; // window is minimized
				}
				else if ( IsWindowVisible( GetConsoleWindow( ) ) )
				{
					return 0; // window is visible
				}
				else
				{
					return 2; // window is hidden
				}
			}
			else
			{
				foreach ( string arg in args )
				{
					string key = arg;
					string val = String.Empty;
					if ( arg.IndexOfAny( ":=".ToCharArray( ) ) > 0 )
					{
						key = arg.Substring( 0, arg.IndexOfAny( ":=".ToCharArray( ) ) );
						val = arg.Substring( arg.IndexOfAny( ":=".ToCharArray( ) ) + 1 );
					}
					switch ( key.ToUpper( ) )
					{
						case "/?":
							return ShowHelp( );
						case "/D":
						case "/DEBUG":
							debugmode = true;
							break;
						case "/HIDE":
							if ( hidewindow )
							{
								return ShowHelp( "Duplicate command line switch /HIDE" );
							}
							if ( showwindow )
							{
								return ShowHelp( "Invalid combination of command line switches /HIDE, /SHOW and/or /TRAY" );
							}
							hidewindow = true;
							break;
						case "/MAX":
						case "/MAXIMIZE":
							if ( maximizewindow )
							{
								return ShowHelp( "Duplicate command line switch /MAX" );
							}
							if ( minimizewindow || normalwindow )
							{
								return ShowHelp( "Invalid combination of command line switches /MAX, /MIN and/or /NORMAL" );
							}
							maximizewindow = true;
							break;
						case "/MIN":
						case "/MINIMIZE":
							if ( minimizewindow )
							{
								return ShowHelp( "Duplicate command line switch /MIN" );
							}
							if ( maximizewindow || normalwindow )
							{
								return ShowHelp( "Invalid combination of command line switches /MAX, /MIN and/or /NORMAL" );
							}
							minimizewindow = true;
							break;
						case "/NOACT":
						case "/NOACTIVE":
						case "/NOACTIVATE":
						case "/DONTACTIVATE":
							if ( !activatewindow )
							{
								return ShowHelp( "Duplicate command line switch /NOACT" );
							}
							activatewindow = false;
							break;
						case "/NORMAL":
						case "/RESTORE":
							if ( normalwindow )
							{
								return ShowHelp( "Duplicate command line switch /NORMAL" );
							}
							if ( maximizewindow || minimizewindow )
							{
								return ShowHelp( "Invalid combination of command line switches /MAX, /MIN and/or /NORMAL" );
							}
							normalwindow = true;
							break;
						case "/SHOW":
							if ( showwindow )
							{
								return ShowHelp( "Duplicate command line switch /SHOW" );
							}
							if ( hidewindow )
							{
								return ShowHelp( "Invalid combination of command line switches /HIDE, /SHOW and/or /TRAY" );
							}
							showwindow = true;
							break;
						default:
							return ShowHelp( "Invalid command line argument \"{0}\"", arg );
					}
				}
			}

			showwindow = showwindow || maximizewindow || minimizewindow || normalwindow;

			#endregion Parse Command Line


			if ( hidewindow )
			{
				HideConsoleWindow( );
			}
			else
			{
				ShowConsoleWindow( );
			}

			return 0;
		}


		static int ShowHelp( params string[] errmsg )
		{
			// restore console visibility before showing help and/or error message
			if ( !IsWindowVisible( GetConsoleWindow( ) ) )
			{
				activatewindow = true;
				hidewindow = false;
				maximizewindow = false;
				minimizewindow = false;
				normalwindow = true;
				showwindow = true;
				ShowConsoleWindow( );
			}


			#region Error Message

			if ( errmsg.Length > 0 )
			{
				List<string> errargs = new List<string>( errmsg );
				errargs.RemoveAt( 0 );
				Console.Error.WriteLine( );
				Console.ForegroundColor = ConsoleColor.Red;
				Console.Error.Write( "ERROR:\t" );
				Console.ForegroundColor = ConsoleColor.White;
				Console.Error.WriteLine( errmsg[0], errargs.ToArray( ) );
				Console.ResetColor( );
			}

			#endregion Error Message


			#region Help Text

			/*
			ConsoleState.exe,  Version 2.00
			Set or get the visibility state of the current console
			
			Usage:    ConsoleState.exe  [ /Hide | /Show [ options ] ]
			
			Where:    /Hide         Hides the console
			          /Show         Shows the console (restores visibility)
			
			Options:  /Max          Maximizes the console
			          /Min          Minimizes the console
			          /Normal       restores the console to its Normal state
			          /NoAct        do Not Activate the console window
			
			Notes:    Command line switches /Max, /Min and /Normal all imply /Show.
			          Options are valid only with /Show, not with /Hide.
			          If no command line argument is used, the program will
			          check the current state and return "errorlevel" 0 if
			          visible, 1 if minimized, 2 if hidden, or -1 on errors.
			          If a command line argument is used, the program will
			          return "errorlevel" 0 if successful, or -1 on errors.
			
			Credits:  Code to hide and show console by Anthony on StackOverflow.com:
			          http://stackoverflow.com/a/15079092
			          Code to check current console state by "dtb" on StackOverflow.com:
			          http://stackoverflow.com/a/2655954
			          Code to check if console is minimized Jim Tat on C# Corner:
			          https://www.c-sharpcorner.com/forums
			          /dreamincodegt-programming-helpgt-c-sharp-hi-snipercode-welcome-t
			          Console state enumeration on PInvoke.net:
			          http://www.pinvoke.net/default.aspx/Enums/ShowWindowCommand.html
			
			Written by Rob van der Woude
			http://www.robvanderwoude.com
			*/

			#endregion Help Text


			#region Display Help Text

			Console.Error.WriteLine( );

			Console.Error.WriteLine( "ConsoleState.exe,  Version {0}", progver );

			Console.Error.WriteLine( "Set or get the visibility state of the current console" );

			Console.Error.WriteLine( );

			Console.Error.Write( "Usage:    " );
			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.WriteLine( "ConsoleState.exe  [ /Hide | /Show [ options ] ]" );
			Console.ResetColor( );

			Console.Error.WriteLine( );

			Console.Error.Write( "Where:    " );
			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.Write( "/Hide         H" );
			Console.ResetColor( );
			Console.Error.WriteLine( "ides the console" );

			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.Write( "          /Show         S" );
			Console.ResetColor( );
			Console.Error.WriteLine( "hows the console (restores visibility)" );

			Console.Error.WriteLine( );

			Console.Error.Write( "Options:  " );
			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.Write( "/Max          Max" );
			Console.ResetColor( );
			Console.Error.WriteLine( "imizes the console" );

			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.Write( "          /Min          Min" );
			Console.ResetColor( );
			Console.Error.WriteLine( "imizes the console" );

			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.Write( "          /Normal" );
			Console.ResetColor( );
			Console.Error.Write( "       restores the console to its " );
			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.Write( "Normal" );
			Console.ResetColor( );
			Console.Error.WriteLine( " state" );

			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.Write( "          /NoAct" );
			Console.ResetColor( );
			Console.Error.Write( "        do " );
			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.Write( "No" );
			Console.ResetColor( );
			Console.Error.Write( "t" );
			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.Write( "Act" );
			Console.ResetColor( );
			Console.Error.WriteLine( "ivate the console window" );

			Console.Error.WriteLine( );

			Console.Error.Write( "Notes:    Command line switches " );
			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.Write( "/Max" );
			Console.ResetColor( );
			Console.Error.Write( ", " );
			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.Write( "/Min" );
			Console.ResetColor( );
			Console.Error.Write( " and " );
			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.Write( "/Normal" );
			Console.ResetColor( );
			Console.Error.Write( " all imply " );
			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.Write( "/Show" );
			Console.ResetColor( );
			Console.Error.WriteLine( "." );

			Console.Error.Write( "          Options are valid only with " );
			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.Write( "/Show" );
			Console.ResetColor( );
			Console.Error.Write( ", not with " );
			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.Write( "/Hide" );
			Console.ResetColor( );
			Console.Error.WriteLine( "." );

			Console.Error.WriteLine( "          If no command line argument is used, the program will" );

			Console.Error.WriteLine( "          check the current state and return \"errorlevel\" 0 if" );

			Console.Error.WriteLine( "          visible, 1 if minimized, 2 if hidden, or -1 on errors." );

			Console.Error.WriteLine( "          If a command line argument is used, the program will" );

			Console.Error.WriteLine( "          return \"errorlevel\" 0 if successful, or -1 on errors." );

			Console.Error.WriteLine( );

			Console.Error.WriteLine( "Credits:  Code to hide and show console by Anthony on StackOverflow.com:" );

			Console.ForegroundColor = ConsoleColor.DarkGray;
			Console.Error.WriteLine( "          http://stackoverflow.com/a/15079092" );
			Console.ResetColor( );

			Console.Error.WriteLine( "          Code to check current console state by \"dtb\" on StackOverflow.com:" );

			Console.ForegroundColor = ConsoleColor.DarkGray;
			Console.Error.WriteLine( "          http://stackoverflow.com/a/2655954" );
			Console.ResetColor( );

			Console.Error.WriteLine( "          Code to check if console is minimized Jim Tat on C# Corner:" );

			Console.ForegroundColor = ConsoleColor.DarkGray;
			Console.Error.WriteLine( "          https://www.c-sharpcorner.com/forums" );
			Console.Error.WriteLine( "          /dreamincodegt-programming-helpgt-c-sharp-hi-snipercode-welcome-t" );
			Console.ResetColor( );

			Console.Error.WriteLine( "          Console state enumeration on PInvoke.net:" );


			Console.ForegroundColor = ConsoleColor.DarkGray;
			Console.Error.WriteLine( "          http://www.pinvoke.net/default.aspx/Enums/ShowWindowCommand.html" );
			Console.ResetColor( );

			Console.Error.WriteLine( );

			Console.Error.WriteLine( "Written by Rob van der Woude" );

			Console.Error.WriteLine( "http://www.robvanderwoude.com" );

			#endregion Display Help Text


			return -1;
		}


		#region Hide or Show Console

		// Source: http://stackoverflow.com/a/15079092
		public static void ShowConsoleWindow( )
		{
			var handle = GetConsoleWindow( );
			if ( handle == IntPtr.Zero )
			{
				AllocConsole( );
			}
			else
			{
				if ( maximizewindow )
				{
					ShowWindow( handle, (int) ShowWindowCommands.ShowMaximized );
				}
				else if ( minimizewindow )
				{
					if ( activatewindow )
					{
						ShowWindow( handle, (int) ShowWindowCommands.ShowMinimized );
					}
					else
					{
						ShowWindow( handle, (int) ShowWindowCommands.ShowMinNoActive );
					}
				}
				else
				{
					ShowWindow( handle, (int) ShowWindowCommands.Show );
					if ( activatewindow )
					{
						ShowWindow( handle, (int) ShowWindowCommands.Restore ); // Restore window size and position
					}
				}
			}
			if ( debugmode )
			{
				Console.Error.WriteLine( "Command Line    = {0}", Environment.CommandLine );
				Console.Error.WriteLine( "activatewindow  = {0}", activatewindow );
				Console.Error.WriteLine( "hidewindow      = {0}", hidewindow );
				Console.Error.WriteLine( "maximizewindow  = {0}", maximizewindow );
				Console.Error.WriteLine( "minimizewindow  = {0}", minimizewindow );
				Console.Error.WriteLine( "normalwindow    = {0}", normalwindow );
				Console.Error.WriteLine( "showwindow      = {0}", showwindow );
				Console.Error.WriteLine( "IsIconic        = {0}", IsIconic( handle ) );
				Console.Error.WriteLine( "IsWindowVisible = {0}", IsWindowVisible( handle ) );
				Console.Error.WriteLine( );
			}
		}


		// Source: http://stackoverflow.com/a/15079092
		public static void HideConsoleWindow( )
		{
			var handle = GetConsoleWindow( );
			ShowWindow( handle, (int) ShowWindowCommands.Hide );
			if ( debugmode )
			{
				Console.Error.WriteLine( "Command Line    = {0}", Environment.CommandLine );
				Console.Error.WriteLine( "activatewindow  = {0}", activatewindow );
				Console.Error.WriteLine( "hidewindow      = {0}", hidewindow );
				Console.Error.WriteLine( "maximizewindow  = {0}", maximizewindow );
				Console.Error.WriteLine( "minimizewindow  = {0}", minimizewindow );
				Console.Error.WriteLine( "normalwindow    = {0}", normalwindow );
				Console.Error.WriteLine( "showwindow      = {0}", showwindow );
				Console.Error.WriteLine( "IsIconic        = {0}", IsIconic( handle ) );
				Console.Error.WriteLine( "IsWindowVisible = {0}", IsWindowVisible( handle ) );
				Console.Error.WriteLine( );
			}
		}


		// Source: http://stackoverflow.com/a/15079092
		[DllImport( "kernel32.dll", SetLastError = true )]
		static extern bool AllocConsole( );


		// Source: http://stackoverflow.com/a/15079092
		[DllImport( "kernel32.dll" )]
		static extern IntPtr GetConsoleWindow( );


		// Source: http://stackoverflow.com/a/15079092
		[DllImport( "user32.dll" )]
		static extern bool ShowWindow( IntPtr hWnd, int nCmdShow );


		// Source: http://stackoverflow.com/a/2655954
		[DllImport( "user32.dll" )]
		[return: MarshalAs( UnmanagedType.Bool )]
		static extern bool IsWindowVisible( IntPtr hWnd );


		[DllImport( "user32.dll" )]
		[return: MarshalAs( UnmanagedType.Bool )]
		static extern bool IsIconic( IntPtr hWnd );

		#endregion Hide or Show Console
	}


	public enum ShowWindowCommands
	{
		// Source: http://www.pinvoke.net/default.aspx/Enums/ShowWindowCommand.html

		/// <summary>
		/// Hides the window and activates another window.
		/// </summary>
		Hide = 0,

		/// <summary>
		/// Activates and displays a window. If the window is minimized or
		/// maximized, the system restores it to its original size and position.
		/// An application should specify this flag when displaying the window
		/// for the first time.
		/// </summary>
		Normal = 1,
		
		/// <summary>
		/// Activates the window and displays it as a minimized window.
		/// </summary>
		ShowMinimized = 2,
		
		/// <summary>
		/// Maximizes the specified window.
		/// </summary>
		Maximize = 3,
		
		/// <summary>
		/// Activates the window and displays it as a maximized window.
		/// </summary>      
		ShowMaximized = 3,
		
		/// <summary>
		/// Displays a window in its most recent size and position. This value
		/// is similar to <see cref="Win32.ShowWindowCommand.Normal"/>, except
		/// the window is not activated.
		/// </summary>
		ShowNoActivate = 4,
		
		/// <summary>
		/// Activates the window and displays it in its current size and position.
		/// </summary>
		Show = 5,
		
		/// <summary>
		/// Minimizes the specified window and activates the next top-level
		/// window in the Z order.
		/// </summary>
		Minimize = 6,
		
		/// <summary>
		/// Displays the window as a minimized window. This value is similar to
		/// <see cref="Win32.ShowWindowCommand.ShowMinimized"/>, except the
		/// window is not activated.
		/// </summary>
		ShowMinNoActive = 7,
		
		/// <summary>
		/// Displays the window in its current size and position. This value is
		/// similar to <see cref="Win32.ShowWindowCommand.Show"/>, except the
		/// window is not activated.
		/// </summary>
		ShowNA = 8,
		
		/// <summary>
		/// Activates and displays the window. If the window is minimized or
		/// maximized, the system restores it to its original size and position.
		/// An application should specify this flag when restoring a minimized window.
		/// </summary>
		Restore = 9,
		
		/// <summary>
		/// Sets the show state based on the SW_* value specified in the
		/// STARTUPINFO structure passed to the CreateProcess function by the
		/// program that started the application.
		/// </summary>
		ShowDefault = 10,
		
		/// <summary>
		///  <b>Windows 2000/XP:</b> Minimizes a window, even if the thread
		/// that owns the window is not responding. This flag should only be
		/// used when minimizing windows from a different thread.
		/// </summary>
		ForceMinimize = 11
	}
}
