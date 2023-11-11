Describe "Utilities v1.ps1" {
    Context "When the user selects option 1" {
        It "should prompt the user for the name of the computer" {
            $mockedInput = "TestComputer"
            Mock Read-Host { $mockedInput } -Verifiable -ParameterFilter { $args[0] -eq "Ingresa el nombre del equipo" }
            $result = .\Utilities v1.ps1
            Assert-MockCalled Read-Host -Times 1 -ParameterFilter { $args[0] -eq "Ingresa el nombre del equipo" }
            Assert-Equals $mockedInput $result.Nombrepc
        }

        It "should prompt the user for the username" {
            $mockedInput = "TestUser"
            Mock Read-Host { $mockedInput } -Verifiable -ParameterFilter { $args[0] -eq "Ingresa el nombre de usuario" }
            $result = .\Utilities v1.ps1
            Assert-MockCalled Read-Host -Times 1 -ParameterFilter { $args[0] -eq "Ingresa el nombre de usuario" }
            Assert-Equals $mockedInput $result.Usuario
        }

        It "should prompt the user for the password" {
            $mockedInput = "TestPassword"
            Mock Read-Host { $mockedInput } -Verifiable -ParameterFilter { $args[0] -eq "Ingresa la clave" }
            $result = .\Utilities v1.ps1
            Assert-MockCalled Read-Host -Times 1 -ParameterFilter { $args[0] -eq "Ingresa la clave" }
            Assert-Equals $mockedInput $result.Password
        }

        It "should prompt the user for the action to perform" {
            $mockedInput = "1"
            Mock Read-Host { $mockedInput } -Verifiable -ParameterFilter { $args[0] -eq "¿Que accion deseas realizar?" }
            $result = .\Utilities v1.ps1
            Assert-MockCalled Read-Host -Times 1 -ParameterFilter { $args[0] -eq "¿Que accion deseas realizar?" }
            Assert-Equals $mockedInput $result.Opcion
        }
    }

    Context "When the user selects option 2" {
        It "should prompt the user for the username" {
            $mockedInput = "TestUser"
            Mock Read-Host { $mockedInput } -Verifiable -ParameterFilter { $args[0] -eq "Ingresa el nombre de usuario" }
            $result = .\Utilities v1.ps1
            Assert-MockCalled Read-Host -Times 1 -ParameterFilter { $args[0] -eq "Ingresa el nombre de usuario" }
            Assert-Equals $mockedInput $result.Usuario
        }

        It "should prompt the user for the password" {
            $mockedInput = "TestPassword"
            Mock Read-Host { $mockedInput } -Verifiable -ParameterFilter { $args[0] -eq "Ingresa la clave" }
            $result = .\Utilities v1.ps1
            Assert-MockCalled Read-Host -Times 1 -ParameterFilter { $args[0] -eq "Ingresa la clave" }
            Assert-Equals $mockedInput $result.Password
        }

        It "should prompt the user for the action to perform" {
            $mockedInput = "2"
            Mock Read-Host { $mockedInput } -Verifiable -ParameterFilter { $args[0] -eq "¿Que accion deseas realizar?" }
            $result = .\Utilities v1.ps1
            Assert-MockCalled Read-Host -Times 1 -ParameterFilter { $args[0] -eq "¿Que accion deseas realizar?" }
            Assert-Equals $mockedInput $result.Opcion
        }
    }

    Context "When the user selects option 3" {
        It "should prompt the user for the username" {
            $mockedInput = "TestUser"
            Mock Read-Host { $mockedInput } -Verifiable -ParameterFilter { $args[0] -eq "Ingresa el nombre de usuario" }
            $result = .\Utilities v1.ps1
            Assert-MockCalled Read-Host -Times 1 -ParameterFilter { $args[0] -eq "Ingresa el nombre de usuario" }
            Assert-Equals $mockedInput $result.Usuario
        }

        It "should prompt the user for the password" {
            $mockedInput = "TestPassword"
            Mock Read-Host { $mockedInput } -Verifiable -ParameterFilter { $args[0] -eq "Ingresa la clave" }
            $result = .\Utilities v1.ps1
            Assert-MockCalled Read-Host -Times 1 -ParameterFilter { $args[0] -eq "Ingresa la clave" }
            Assert-Equals $mockedInput $result.Password
        }

        It "should prompt the user for the action to perform" {
            $mockedInput = "3"
            Mock Read-Host { $mockedInput } -Verifiable -ParameterFilter { $args[0] -eq "¿Que accion deseas realizar?" }
            $result = .\Utilities v1.ps1
            Assert-MockCalled Read-Host -Times 1 -ParameterFilter { $args[0] -eq "¿Que accion deseas realizar?" }
            Assert-Equals $mockedInput $result.Opcion
        }
    }
}