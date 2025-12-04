using Godot;
using System;

public partial class Treno : PathFollow2D
{
	// Velocità in pixel al secondo
	[Export]
	public float Speed = 100.0f;

	public override void _Ready()
	{
		// Disabilita il loop se vuoi che il treno si fermi alla fine
		// Lascialo a true se è un circuito chiuso
		Loop = true;
	}

	public override void _Process(double delta)
	{
		// Muove il treno lungo il percorso
		// Progress è la distanza percorsa in pixel
		Progress += Speed * (float)delta;
	}
}
