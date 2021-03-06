<?php
#############################################################################
##   MonsterfyMVC - MVC Framework for PHP + MySQL                          ##
##   Copyright (C) 2012  Leandro Medeiros                                  ##
##                                                                         ##
##   This program is free software: you can redistribute it and/or modify  ##
##   it under the terms of the GNU General Public License as published by  ##
##   the Free Software Foundation, either version 3 of the License, or     ##
##   (at your option) any later version.                                   ##
##                                                                         ##
##   This program is distributed in the hope that it will be useful,       ##
##   but WITHOUT ANY WARRANTY; without even the implied warranty of        ##
##   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         ##
##   GNU General Public License for more details.                          ##
##                                                                         ##
##   You should have received a copy of the GNU General Public License     ##
##   along with this program.  If not, see <http://www.gnu.org/licenses/>. ##
##                                                                         ##
#############################################################################

/**
 * Controller do System
 *
 * @package controllers
 * @author  Leandro Medeiros
 * @since   2015-07-09
 * @link    http://bitbucket.org/leandro_medeiros/monsterfymvc
 */
class SystemController extends BaseController {	
    /**
     * Id do módulo correspondente à Controller
     * @var string
     */
    public static $moduleId = 1;


    /**
     * Exibir HomePage (override)
     *
     * @method goHome
     * @param  boolean $forceRefresh Forçar atualização dos Dados
     * @return mixed Página
     * @author Leandro Medeiros
     * @since  2015-07-09
     * @link   http:/bitbucket.org/leandro_medeiros/monsterfymvc
     */
	public function goHome($forceRefresh = false) {
        return $this->getUsers();
    }

    /**
     * Listar Usuários
     *
     * @author Leandro Medeiros <leandro.medeiros@live.com>
     * @since  2016-01-30
     * 
     * @param  array     $arguments Filtros
     * @return View
     */
    public function getUsers($arguments = null) {
        $list = User::getList();

        return $this->View->load($list);
    }
}
