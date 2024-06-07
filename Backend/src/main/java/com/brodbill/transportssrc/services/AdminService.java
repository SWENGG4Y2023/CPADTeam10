package com.brodbill.transportssrc.services;

import com.brodbill.transportssrc.dto.request.*;
import com.brodbill.transportssrc.model.*;
import com.brodbill.transportssrc.model.consts.AccountRole;
import com.brodbill.transportssrc.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AdminService {

    @Autowired
    AccountRepository accountRepository;

    @Autowired
    AdminRepository adminRepository;

    @Autowired
    DriverRepository driverRepository;

    @Autowired
    AccountantRepository accountantRepository;

    @Autowired
    CustomerRepository customerRepository;

    @Autowired
    VehicleRepository vehicleRepository;

    @Autowired
    OrderRepository orderRepository;

    @Autowired
    TripRepository tripRepository;

    public List<Account> getAllUsers() {
        return accountRepository.findAll();
    }

    public List<Admin> getAllAdmins() {
        return adminRepository.findAll();
    }

    public List<Driver> getAllDrivers() {
        return driverRepository.findAll();
    }

    public List<Accountant> getAllAccountants() {
        return accountantRepository.findAll();
    }

    public List<Customer> getAllCustomers() {
        return customerRepository.findAll();
    }

    public List<Vehicle> getAllVehicles() {
        return vehicleRepository.findAll();
    }

    public List<Orders> getAllOrders() {
        return orderRepository.findAll();
    }

    public List<Trip> getAllTrips() {
        return tripRepository.findAll();
    }

    public Boolean changeAccountStatus(String email, Boolean isEnabled) {
        Account account = accountRepository.findByEmail(email);
        account.setIsActive(isEnabled);
        accountRepository.save(account);
        return true;
    }

    public Boolean createAdmin(AdminRegisterDto adminRegisterDto) {
        Admin admin = new Admin();
        Account account = new Account();
        account.setName(adminRegisterDto.getName());
        account.setEmail(adminRegisterDto.getEmail());
        account.setPassword(adminRegisterDto.getPassword());
        account.setIsActive(true);
        account.setRoles(List.of(AccountRole.ROLE_ADMIN));
        accountRepository.save(account);
        admin.setAccount(account);
        adminRepository.save(admin);
        return true;
    }

    public Boolean createDriver(DriverRegisterDto driverRegisterDto) {
        Driver driver = new Driver();
        Account account = new Account();
        BankAccount bankAccount = new BankAccount();
        account.setName(driverRegisterDto.getName());
        account.setEmail(driverRegisterDto.getEmail());
        account.setPassword(driverRegisterDto.getPassword());
        account.setIsActive(true);
        account.setRoles(List.of(AccountRole.ROLE_DRIVER));
        accountRepository.save(account);
        driver.setAccount(account);
        driver.setLicenseNumber(driverRegisterDto.getLicenseNumber());
        driver.setLicenseType(driverRegisterDto.getLicenseType());
        driver.setLicenseExpiryDate(driverRegisterDto.getLicenseExpiryDate());
        driver.setLicenseIssueDate(driverRegisterDto.getLicenseIssueDate());
        bankAccount.setBankName(driverRegisterDto.getBankName());
        bankAccount.setAccountNumber(driverRegisterDto.getBankAccountNumber());
        bankAccount.setAccountType(driverRegisterDto.getBankAccountType());
        bankAccount.setIFSCCode(driverRegisterDto.getBankIFSCCode());
        bankAccount.setBeneficiaryName(driverRegisterDto.getBankBeneficiaryName());
        driver.setBankAccount(bankAccount);
        driverRepository.save(driver);
        return true;
    }

    public Boolean createAccountant(AccountantRegisterDto accountantRegisterDto) {
        Accountant accountant = new Accountant();
        Account account = new Account();
        BankAccount bankAccount = new BankAccount();
        account.setName(accountantRegisterDto.getName());
        account.setEmail(accountantRegisterDto.getEmail());
        account.setPassword(accountantRegisterDto.getPassword());
        account.setIsActive(true);
        account.setRoles(List.of(AccountRole.ROLE_ACCOUNTANT));
        accountRepository.save(account);
        bankAccount.setBankName(accountantRegisterDto.getBankName());
        bankAccount.setAccountNumber(accountantRegisterDto.getBankAccountNumber());
        bankAccount.setAccountType(accountantRegisterDto.getBankAccountType());
        bankAccount.setIFSCCode(accountantRegisterDto.getBankIFSCCode());
        bankAccount.setBeneficiaryName(accountantRegisterDto.getBankBeneficiaryName());
        accountant.setBankAccount(bankAccount);
        accountant.setAccount(account);
        accountantRepository.save(accountant);
        return true;
    }

    public Boolean createVehicle(VehicleRegisterDto vehicleRegisterDto) {
        Vehicle vehicle = new Vehicle();
        vehicle.setVehicleNumber(vehicleRegisterDto.getVehicleNumber());
        vehicle.setVehicleType(vehicleRegisterDto.getVehicleType());
        vehicle.setVehicleCapacity(vehicleRegisterDto.getVehicleCapacity());
        vehicle.setVehicleModel(vehicleRegisterDto.getVehicleModel());
        vehicle.setVehicleRegistrationDate(vehicleRegisterDto.getVehicleRegistrationDate());
        vehicleRepository.save(vehicle);
        return true;
    }

    public Boolean updateAccount(AccountUpdateDto accountUpdateDto) {
        Account account = accountRepository.findByEmail(accountUpdateDto.getEmail());
        account.setName(accountUpdateDto.getName());
        account.setRoles(accountUpdateDto.getRoles());
        accountRepository.save(account);
        return true;
    }

    public Boolean changeAccountPassword(AccountPasswordUpdateDto accountPasswordUpdateDto) {
        Account account = accountRepository.findByEmail(accountPasswordUpdateDto.getEmail());
        if(account.getPassword().equals(accountPasswordUpdateDto.getOldPassword())) {
            account.setPassword(accountPasswordUpdateDto.getNewPassword());
            accountRepository.save(account);
            return true;
        } else {
            return false;
        }
    }

    public Boolean updateVehicle(VehicleUpdateDto vehicleUpdateDto) {
        Vehicle vehicle = vehicleRepository.findByVehicleNumber(vehicleUpdateDto.getVehicleNumber());
        vehicle.setVehicleType(vehicleUpdateDto.getVehicleType());
        vehicle.setVehicleCapacity(vehicleUpdateDto.getVehicleCapacity());
        vehicle.setVehicleModel(vehicleUpdateDto.getVehicleModel());
        vehicle.setVehicleRegistrationDate(vehicleUpdateDto.getVehicleRegistrationDate());
        vehicleRepository.save(vehicle);
        return true;
    }

    public Boolean deleteVehicle(String vehicleNumber) {
        Vehicle vehicle = vehicleRepository.findByVehicleNumber(vehicleNumber);
        vehicleRepository.delete(vehicle);
        return true;
    }

    public Boolean deleteUserAccount(String email) {
        Account account = accountRepository.findByEmail(email);
        account.getRoles().forEach(role -> {
            if(role.equals(AccountRole.ROLE_ADMIN)) {
                Admin admin = adminRepository.findByAccount(account);
                adminRepository.delete(admin);
            } else if(role.equals(AccountRole.ROLE_DRIVER)) {
                Driver driver = driverRepository.findByAccount(account);
                driverRepository.delete(driver);
            } else if(role.equals(AccountRole.ROLE_ACCOUNTANT)) {
                Accountant accountant = accountantRepository.findByAccount(account);
                accountantRepository.delete(accountant);
            }
        });
        accountRepository.delete(account);
        return true;
    }

    public Boolean createCustomer(CustomerRegisterDto customerRegisterDto) {
        Customer customer = new Customer();
        BankAccount bankAccount = new BankAccount();
        customer.setName(customerRegisterDto.getName());
        customer.setAddress(customerRegisterDto.getAddress());
        customer.setEmail(customerRegisterDto.getEmail());
        customer.setPhone(customerRegisterDto.getPhone());
        customer.setGstNumber(customerRegisterDto.getGstNumber());
        customer.setPanNumber(customerRegisterDto.getPanNumber());
        bankAccount.setBankName(customerRegisterDto.getBankName());
        bankAccount.setAccountNumber(customerRegisterDto.getBankAccountNumber());
        bankAccount.setAccountType(customerRegisterDto.getBankAccountType());
        bankAccount.setIFSCCode(customerRegisterDto.getBankIfsc());
        bankAccount.setBeneficiaryName(customerRegisterDto.getBeneficiaryName());
        customer.setBankAccount(bankAccount);
        customerRepository.save(customer);
        return true;

    }
}
