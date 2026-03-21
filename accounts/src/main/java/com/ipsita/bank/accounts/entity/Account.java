package com.ipsita.bank.accounts.entity;

import jakarta.persistence.*;
import lombok.*;


@Entity
@Table(name="Accounts")
@Getter @Setter @ToString @NoArgsConstructor
public class Account extends BaseEntity{

    @Column(name="customer_id")
    private Long customerId;

    @Id
    @Column(name="account_id")
    private Long accountNumber ;

    @Column(name="account_type")
    private String accountType ;

    @Column(name="branch_address")
    private String branchAddress ;

}
