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
        SimpleDateFormat dF = new SimpleDateFormat("dd/MM/yyyy"); //Formatador de datas
        SimpleDateFormat hF = new SimpleDateFormat("HH:mm"); //Formatador de horas
        Date periodoInicio;
        Date periodoFim;
        Banco bb = new Banco();
        DAOJPA daoJ;
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
                daoJ = new DAOJPA();
                Vacina choice = daoJ.vacinaByDescr(bb, request.getParameter("txtVacina"));
                LoteJpaController daoL = new LoteJpaController(Banco.conexao);
                UsuarioJpaController daoU = new UsuarioJpaController(Banco.conexao);
                //dao = new DAOJPA();
                num_vacinados = 0;
                /*List<Vacinacao> listaV;
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
                num_vacinados = listaU.size();*/
                List<Usuario> listaU = daoU.findUsuarioEntities();
                int a = 0, b = 0;
                for(int i = 0; i < listaU.size(); i++)
                {
                    a++;
                    boolean achou = false;
                    Usuario aux = listaU.get(i);
                    if(!aux.getAgendaList().isEmpty())
                    {
                        List<Agenda>listaA = aux.getAgendaList();
                        for(int j = 0; j < listaA.size(); j++)
                        {
                            if(!achou)
                            {
                                Agenda ag = listaA.get(j);
                                if(!ag.getVacinacaoList().isEmpty())
                                {
                                    Vacinacao vac = ag.getVacinacaoList().get(0);
                                    b ++;
                                    if((periodoInicio.before(vac.getDataAplicacao()) || periodoInicio.equals(vac.getDataAplicacao()))&&(periodoFim.after(vac.getDataAplicacao()) || periodoFim.equals(vac.getDataAplicacao())))
                                    {
                                        if(vac.getCodigoLote().getCodigoVacina().equals(choice))
                                        {
                                            num_vacinados ++;
                                            achou = true;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                List<Lote> listaL = daoL.findLoteEntities();
                int qtdeDoses = 0;
                for(int i = 0; i < listaL.size(); i++)
                {
                    if(listaL.get(i).getCodigoVacina().equals(choice))
                    {
                        qtdeDoses += listaL.get(i).getDoseDisponivel();
                    }
                }
                //2.1: TABELA
%>
                <h3>Relatório gerencial de <%=dF.format(periodoInicio)%> a <%=dF.format(periodoFim)%></h3>
                <h4> Doses disponíveis e pessoas vacinadas com <%=choice.getDescricao()%></h4>
                <table border="1">
                    <thead>
                        <tr>
                            <th>Qtde de Doses</th>
                            <th>Num. de pessoas vacinadas</th>
                            <th>a</th>
                            <th>b</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><%=qtdeDoses%></td>
                            <td><%=num_vacinados%></td>
                            <td><%=a%></td>
                            <td><%=b%></td>
                        </tr>
                    </tbody>
                </table>
                <%
                    List<MovimentoVacina> listaM = daoJ.movimentosRelatorio(bb, periodoInicio, periodoFim, choice);
                    if(listaM == null || listaM.isEmpty())
                        throw new Exception("Lista nula ou vazia");
                %>
                <h4> Movimentos em lotes de <%=choice.getDescricao()%>. Quantidade: <%=listaM.size()%></h4>
                <table border="1">
                    <thead>
                        <tr>
                            <th>Código</th>
                            <th>Data do movimento</th>
                            <th>Hora do movimento</th>
                            <th>Tipo</th>
                            <th>Quantidade</th>
                            <th>Lote</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for( int i = 0; i < listaM.size(); i++)
                            {     
                                
                                MovimentoVacina m = listaM.get(i);
                        %>   
                        <tr>
                            <td><%=m.getCodigo()%></td>
                            <td><%=dF.format(m.getDataMovimento())%></td>
                            <td><%=hF.format(m.getDataMovimento())%></td>
                            <td><%=m.getTipoMovimento()%></td>
                            <td><%=m.getQtdeDose()%></td>
                            <td><%=m.getCodigoLote().getDescricao()%></td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
<%
            }
        Banco.conexao.close();
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
