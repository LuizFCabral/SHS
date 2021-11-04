<%-- 
    Document   : relatorio
    Created on : 02/11/2021, 22:35:28
    Author     : vinif
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="model.*"%>
<%@page import="controller.*"%>
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
        SimpleDateFormat dF = new SimpleDateFormat("dd/MM/yyyy");
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
                    Movimentos da vacina: <input type="text" name="txtVacina"> <br/>
                    <input type="submit" value="Gerar relatório" name="b1"/>
                </form>
<%
            } 
            //2. GERAÇÃO DE RELATÓRIO SOLICITADA: PREENCHENDO AS TABELAS
            else {
                periodoInicio = dF.parse(request.getParameter("txtPeriodoInicio"));
                periodoFim = dF.parse(request.getParameter("txtPeriodoFim"));
                LoteJpaController daoL = new LoteJpaController(Banco.conexao);
                bb = new Banco();
                dao = new DAOJPA();
                num_vacinados = 0;
                List<Vacinacao> listaV;
                ArrayList<Usuario> listaU = new ArrayList<>();
                listaV = dao.vacinasPeriodo(bb, periodoInicio, periodoFim);
                for(int i = 0; i < listaV.size(); i++)
                {
                    Vacinacao atual = listaV.get(i);
                    if(listaU != null)
                        for(int j = 0; i < listaU.size(); i++)
                        {
                            if(!atual.getCodigoUsuario().equals(listaU.get(i)))
                            {
                                listaU.add(atual.getCodigoUsuario());
                            }
                        }
                    else
                    {
                        listaU.add(atual.getCodigoUsuario());
                    }
                }
                num_vacinados = listaU.size();
                List<Lote> listaL = daoL.findLoteEntities();
                int qtdeDoses = 0;
                for(int i = 0; i < listaL.size(); i++)
                {
                    qtdeDoses += listaL.get(i).getDoseDisponivel();
                }
                //2.1: TABELA
%>
                <table border="1">
                    <thead>
                        <tr>
                            <th>Num. de Vacinados</th>
                            <th>Qtde de Doses</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><%=num_vacinados%></td>
                            <td><%=qtdeDoses%></td>
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
