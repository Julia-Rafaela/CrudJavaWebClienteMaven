<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<link rel="stylesheet" href="./css/styles.css">
<title>Cliente</title>
</head>
<body>
	<div>
		<jsp:include page="menu.jsp" />
	</div>
	<br />
	<div align="center" class="container">
		<form action="cliente" method="post">
			<p class="title">
				<b>Cliente</b>
			</p>

			<table>
				<tr>
					<td colspan="3"><input class="input_data" type="number"
						id="CPF" name="CPF" placeholder="CPF"
						value='<c:out value="${cliente.CPF }"></c:out>'></td>
					<td><input type="submit" id="botao" name="botao"
						value="Buscar"></td>
				</tr>
				<tr>
					<td colspan="4"><input class="input_data" type="text"
						id="nome" name="nome" placeholder="Nome"
						value='<c:out value="${cliente.nome }"></c:out>'></td>
				</tr>
				<tr>
					<td colspan="4"><input class="input_data" type="text"
						id="email" name="email" placeholder="Email"
						value='<c:out value="${cliente.email }"></c:out>'></td>
				</tr>
				<tr>
					<td colspan="4"><input class="input_data" type="text"
						id="limiteCredito" name="limiteCredito"
						placeholder="Limite de Credito"
						value='<c:out value="${cliente.limiteCredito }"></c:out>'></td>
				</tr>

				<tr>
					<td colspan="4"><input class="input_data" type="text"
						id="dataNascimento" name="dataNascimento"
						placeholder="Data Nascimento"
						value='<c:out value="${cliente.dataNascimento }"></c:out>'>
					</td>
				</tr>


				<tr>
					<td><input type="submit" id="botao" name="botao"
						value="Cadastrar"></td>
					<td><input type="submit" id="botao" name="botao"
						value="Alterar"></td>
					<td><input type="submit" id="botao" name="botao"
						value="Excluir"></td>

					<td><input type="submit" id="botao" name="botao"
						value="Listar"></td>

				</tr>
			</table>
		</form>
	</div>
	<br />
	<div align="center">
		<c:if test="${not empty erro }">
			<h2>
				<b><c:out value="${erro }" /></b>
			</h2>
		</c:if>
	</div>

	<br />
	<div align="center">
		<c:if test="${not empty saida }">
			<h3>
				<b><c:out value="${saida }" /></b>
			</h3>
		</c:if>
	</div>

	<br />
	<div align="center">
		<c:if test="${not empty clientes }">
			<table class="table_round">
				<thead>
					<tr>
						<th>CPF</th>
						<th>Nome</th>
						<th>Email</th>
						<th>Limite de Credito</th>
						<th>Data Nascimento</th>

					</tr>
				</thead>
				<tbody>
					<c:forEach var="c" items="${clientes }">
						<tr>
							<td><c:out value="${c.CPF }" /></td>
							<td><c:out value="${c.nome }" /></td>
							<td><c:out value="${c.email }" /></td>
							<td><c:out value="${c.limiteCredito }" /></td>
							<td><c:out value="${c.dataNascimento }" /></td>
						</tr>
					</c:forEach>

				</tbody>

			</table>
		</c:if>
	</div>
</body>
</html>