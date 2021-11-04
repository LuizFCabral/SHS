<%-- 
    Document   : relatorio
    Created on : 02/11/2021, 22:35:28
    Author     : vinif
--%>

<%@page import="controller.DAOJPA"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="model.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Relatório</title>
    </head>
    <body>
<%
        response.setCharacterEncoding("UTF-8");
        
        //VARIÁVEIS
        SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
        Date periodoInicio;
        Date periodoFim;
        Banco bb;
        DAOJPA dao;
        int num_vacinados;
        
        try {
            //RESTRIÇÃO DE ACESSO
            if(session.getAttribute("login") == null || session.getAttribute("classe") != UsuarioApl.class)
                throw new Exception("Log-in não feito ou credenciais insuficientes");
            
            //RELATÓRIOS
            //1. PRIMEIRA VEZ A RODAR: HTML BÁSICO DO RELATÓRIO
            if(request.getParameter("b1") == null) {
%>
                <form action="relatorio.jsp" method="POST">
                    Início: <input type="text" name="txtPeriodoInicio"> <br/>
                    Fim: <input type="text" name="txtPeriodoFim"> <br/>
                    <input type="submit" value="Gerar relatório" name="b1" />
                </form>
<%
            } 
            //2. GERAÇÃO DE RELATÓRIO SOLICITADA: PREENCHENDO AS TABELAS
            else {
                periodoInicio = df.parse(request.getParameter("txtPeriodoInicio"));
                periodoFim = df.parse(request.getParameter("txtPeriodoFim"));
                bb = new Banco();
                dao = new DAOJPA();
                num_vacinados = dao.pessoasVacinadas(bb, periodoInicio, periodoFim);

                //2.1: TABELA
%>
                <table border="1">
                    <thead>
                        <tr>
                            <th>Vacinados</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><%=num_vacinados%></td>
                        </tr>
                    </tbody>
                </table>
<%
            }
        } 
        catch (Exception ex) {
            Banco.conexao.close();
%>
            <h1>Erro: <%=ex.getMessage()%></h1> Clique <a href="relatorio.jsp">aqui</a> para voltar à página de relatório.
<%
        }
%>
    </body>
</html>
