package controlle;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Cliente;
import percistencia.ClienteDao;
import percistencia.GenericDao;

@WebServlet("/cliente")
public class ClienteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public ClienteServlet() {
		super();

	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		RequestDispatcher rd = request.getRequestDispatcher("cliente.jsp");
		rd.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// entrada
		String cmd = request.getParameter("botao");
		String CPF = request.getParameter("CPF");
		String nome = request.getParameter("nome");
		String email = request.getParameter("email");
		String limiteCredito = request.getParameter("limiteCredito");
		String dataNascimento = request.getParameter("dataNascimento");

		// saida
		String saida = "";
		String erro = "";
		Cliente c = new Cliente();
		List<Cliente> clientes = new ArrayList<>();

		if (!cmd.contains("Listar")) {
			c.setCPF(CPF);
		}
		if (cmd.contains("Cadastrar") || cmd.contains("Alterar")) {
			c.setNome(nome);
			c.setEmail(email);
			c.setLimiteCredito(Float.parseFloat(limiteCredito));
			c.setDataNascimento(dataNascimento);
		}
		try {
			if (cmd.contains("Cadastrar")) {
				saida = cadastrarProfessor(c);
				c = null;
			}
			if (cmd.contains("Alterar")) {
				saida = alterarProfessor(c);
				c = null;
			}
			if (cmd.contains("Excluir")) {
				saida = excluirProfessor(c);
				c = null;
			}
			if (cmd.contains("Buscar")) {
				c = buscarProfessor(c);
			}
			if (cmd.contains("Listar")) {
				clientes = listarProfessores();
			}
		} catch (SQLException | ClassNotFoundException e) {
			erro = e.getMessage();
		} finally {
			request.setAttribute("saida", saida);
			request.setAttribute("erro", erro);
			request.setAttribute("cliente", c);
			request.setAttribute("clientes", clientes);

			RequestDispatcher rd = request.getRequestDispatcher("cliente.jsp");
			rd.forward(request, response);
		}
	}

	private String cadastrarProfessor(Cliente p) throws SQLException, ClassNotFoundException {
		GenericDao gDao = new GenericDao();
		ClienteDao pDao = new ClienteDao(gDao);
		String saida = pDao.iudCliente("I", p);
		return saida;

	}

	private String alterarProfessor(Cliente p) throws SQLException, ClassNotFoundException {
		GenericDao gDao = new GenericDao();
		ClienteDao pDao = new ClienteDao(gDao);
		String saida = pDao.iudCliente("U", p);
		return saida;

	}

	private String excluirProfessor(Cliente p) throws SQLException, ClassNotFoundException {
		GenericDao gDao = new GenericDao();
		ClienteDao pDao = new ClienteDao(gDao);
		String saida = pDao.iudCliente("D", p);
		return saida;

	}

	private Cliente buscarProfessor(Cliente p) throws SQLException, ClassNotFoundException {
		GenericDao gDao = new GenericDao();
		ClienteDao pDao = new ClienteDao(gDao);
		p = pDao.consultar(p);
		return p;

	}

	private List<Cliente> listarProfessores() throws SQLException, ClassNotFoundException {
		GenericDao gDao = new GenericDao();
		ClienteDao pDao = new ClienteDao(gDao);
		List<Cliente> professores = pDao.listar();

		return professores;
	}

}
