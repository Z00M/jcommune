/**
 * Copyright (C) 2011  JTalks.org Team
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 */
package org.jtalks.jcommune.web.rememberme;

import org.mockito.Mock;
import static org.mockito.Mockito.when;
import org.mockito.MockitoAnnotations;
import org.springframework.security.web.authentication.rememberme.PersistentRememberMeToken;
import org.springframework.security.web.authentication.rememberme.PersistentTokenRepository;
import org.testng.Assert;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;

/**
 * 
 * @author Anuar_Nurmakanov
 *
 */
public class RememberMeCheckServiceTest {
    private static final String PRESENTED_SERIES = "61ikbvB7Nd1Wk3jDXgN/TQ==";
    private static final String PRESENTED_TOKEN = "FGGNNSS0KoIg7zO9+VlSaw==";
    private static final String BROKED_TOKEN = "FGGNNSS0KoIg7zO9+VlSaw=";
    
    @Mock
    private PersistentTokenRepository persistentTokenRepository;
    private RememberMeCheckService rememberMeCheckService;

    @BeforeMethod
    public void init() {
        MockitoAnnotations.initMocks(this);
        this.rememberMeCheckService = new RememberMeCheckService(persistentTokenRepository);
    }
    
    @Test
    public void notExistPersistentTokenShouldNotPassCheck() {
        PersistentRememberMeToken notExistsPersistentRememberMeToken = null;
        when(persistentTokenRepository.getTokenForSeries(PRESENTED_SERIES))
            .thenReturn(notExistsPersistentRememberMeToken);

        boolean isLogged = 
                rememberMeCheckService.checkWithPersistentRememberMeToken(PRESENTED_SERIES, PRESENTED_TOKEN);
        
        Assert.assertFalse(isLogged);
    }
    
    @Test
    public void notEqualPersistentTokenShouldNotPassCheck() {
        PersistentRememberMeToken notEqualPersistentRememberMeToken = 
                new PersistentRememberMeToken("username", PRESENTED_SERIES, BROKED_TOKEN, null);
        
        when(persistentTokenRepository.getTokenForSeries(PRESENTED_SERIES))
            .thenReturn(notEqualPersistentRememberMeToken);

        boolean isLogged = 
                rememberMeCheckService.checkWithPersistentRememberMeToken(PRESENTED_SERIES, PRESENTED_TOKEN);
        
        Assert.assertTrue(isLogged);
    }
    
    @Test
    public void equalPersistentTokenShouldPassCheck() {
        PersistentRememberMeToken notEqualPersistentRememberMeToken = 
                new PersistentRememberMeToken("username", PRESENTED_SERIES, PRESENTED_TOKEN, null);
        
        when(persistentTokenRepository.getTokenForSeries(PRESENTED_SERIES))
            .thenReturn(notEqualPersistentRememberMeToken);

        boolean isLogged = 
                rememberMeCheckService.checkWithPersistentRememberMeToken(PRESENTED_SERIES, PRESENTED_TOKEN);
        
        Assert.assertFalse(isLogged);
    }
}
