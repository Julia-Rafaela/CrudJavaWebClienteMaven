package percistencia;

import java.sql.SQLException;

import model.Cliente;

public interface IClienteDao {
	public String iudCliente(String acao, Cliente p) throws SQLException, ClassNotFoundException;
	
}
