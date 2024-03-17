package controlle;

import java.sql.CallableStatement;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import model.Cliente;
import percistencia.GenericDao;
import percistencia.IClienteDao;
import percistencia.ICrud;

public class ClienteDao implements ICrud<Cliente>, IClienteDao {
	private GenericDao gDao;
	

	public ClienteDao(GenericDao gDao) {
		this.gDao = gDao;
	}

	@Override
	public Cliente consultar(Cliente p) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "SELECT CPF, nome, email, limiteCredito, dataNascimento FROM cliente WHERE CPF = ?";
		PreparedStatement ps = c.prepareStatement(sql);
	    ps.setString(1, p.getCPF());
	    ResultSet rs = ps.executeQuery();
	     if (rs.next()) {
	    	 p.setCPF(rs.getString("CPF"));
	    	 p.setNome(rs.getString("nome"));
	    	 p.setEmail(rs.getString("email"));
	    	 p.setLimiteCredito(rs.getFloat("limiteCredito"));
	         p.setDataNascimento(rs.getString("dataNascimento"));
	    	 
	    	 
	     }
	        rs.close();
			ps.close();
			c.close();
		return p;
	}

	@Override
	public List<Cliente> listar() throws SQLException, ClassNotFoundException {
		
		List<Cliente> Clientes = new ArrayList<>();	
		Connection c = gDao.getConnection();
		String sql = "SELECT CPF, nome, email, limiteCredito, dataNascimento FROM cliente";
		PreparedStatement ps = c.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();
		 while (rs.next()) {			 
			 Cliente cli = new Cliente();
			 cli.setCPF(rs.getString("CPF"));
			 cli.setNome(rs.getString("nome"));
			 cli.setEmail(rs.getString("email"));
			 cli.setLimiteCredito(rs.getFloat("limiteCredito"));	
			 cli.setDataNascimento(rs.getString("dataNascimento"));
			
			 Clientes.add(cli);
		 }
		 rs.close();
		 ps.close();
		 c.close();
		return Clientes;
	}

	@Override
	// Função que Realiza Insert, Update, Delete
	public String iudCliente(String acao, Cliente p) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_iud_cliente (?,?,?,?,?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, acao);
		cs.setString(2, p.getCPF());
		cs.setString(3, p.getNome());
		cs.setString(4, p.getEmail());
		cs.setFloat(5, p.getLimiteCredito());
		cs.setString(6, p.getDataNascimento());
		cs.registerOutParameter(7, Types.VARCHAR);
		cs.execute();
		String saida = cs.getString(7);
		cs.close();
		c.close();
		
		return saida;
	}

}