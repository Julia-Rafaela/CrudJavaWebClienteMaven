package model;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter

public class Cliente {
	 String CPF;
	 String nome;
	 String email;
	 float limiteCredito; 
	 String dataNascimento;
	 
	@Override
	public String toString() {
		return nome;
	}
}