<%-- 
    Document   : atualizarVacina
    Created on : 09/10/2021, 17:14:15
    Author     : Pedro
--%>

<%@page import="controller.MovimentoVacinaJpaController"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.security.Timestamp"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="model.MovimentoVacina"%>
<%@page import="model.Vacina"%>
<%@page import="controller.UsuarioJpaController"%>
<%@page import="controller.DAOJPA"%>
<%@page import="model.Banco"%>
<%@page import="model.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Confirmar aplicação de vacina</title>
    </head>
    <body>
        <%
            request.setCharacterEncoding("UTF-8");
            Usuario u = new Usuario();
            Banco bb = new Banco();
            DAOJPA daoJ = new DAOJPA();
            SimpleDateFormat dF = new SimpleDateFormat("dd/MM/yyyy");
            SimpleDateFormat dFHora = new SimpleDateFormat("dd/MM/yyyy hh:mm:ss");
            MovimentoVacinaJpaController dao = new MovimentoVacinaJpaController(Banco.conexao);
            try
            {
                if(request.getParameter("b1") == null)
                {
        %>
        <form action="atualizarVacina.jsp">
            CPF: <input type="text" name="txtCPF"/>
            <input type="submit" name="b1" value="Procurar"/>
        </form>
        <%
                }
                else
                {
                    if(request.getParameter("b1").equalsIgnoreCase("Procurar"))
                    {
                        u = (Usuario) daoJ.searchCPF(bb, request.getParameter("txtCPF"), u.getClass());
        %>
                    <form action="atualizarVacina.jsp">
                        <h1>Dados da pessoa</h1>
                        CPF: <input type="text" name="txtCPF" value="<%=u.getCpf()%>" readonly/> <br/>
                        Código: <input type="text" name="txtCodigo" value="<%=u.getCodigo()%>" readonly/> <br/>
                        Nome: <input type="text" name="txtNome" value="<%=u.getNome()%>" readonly/> <br/>
                        Data de nascimento: <input type="date" name="txtDataNasc" value="<%=dF.format(u.getDataNascimento())%>"/> <br/>
                        Cidade:<input type="text" name="txtCidade" value="<%=u.getCidade()%>"/> <br/>
                        <h1>Dados da vacina</h1>
                        Descrição: <input type="text" name="txtDescr"/><br/>
                        Lote utilizado: <input type="text" name="txtLote"/><br/>
                        <input type="submit" name="b1" value="confirmar"/>
                    </form>
        
        <%
                    }

                    if(request.getParameter("b1").equalsIgnoreCase("confirmar"))
                    {
                        Vacina v = new Vacina();
                        UsuarioJpaController daoU = new UsuarioJpaController(Banco.conexao);
                        int cod = Integer.parseInt(request.getParameter("txtCodigo"));
                        u = daoU.findUsuario(cod); //pega o obj usuário 
                        String descr = request.getParameter("txtDescr");
                        v = daoJ.vacinaByDescr(bb, descr); //pega o obj vacina
                        MovimentoVacina mov = new MovimentoVacina();
                        mov.setTipoMovimento("S");
                        mov.setCodigoVacina(v);
                        mov.setQtde(1);
                        int lote = Integer.parseInt(request.getParameter("txtLote"));
                        mov.setLote(lote);
                        //mov.setDataMovimento(dFHora.parse(LocalDateTime.now().toString()));
                        dao.create(mov);
                        %>pronto!<%
                        Banco.conexao.close();
                    }
                }
            }
            catch(Exception ex)
            {
                Banco.conexao.close();
%>
                <h1>Erro: <%=ex.getMessage()%></h1>
<%
            }
        %>
    </body>
</html>
