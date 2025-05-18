package com.etekhno.rentacar;

import com.etekhno.rentacar.datamodel.Party;
import com.etekhno.rentacar.datamodel.UserCredential;
import com.etekhno.rentacar.datamodel.enums.Gender;
import com.etekhno.rentacar.datamodel.repo.PartyRepo;
import com.etekhno.rentacar.datamodel.repo.UserCredentialRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Profile;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
@Profile("test")
public class DataHelper {

    @Autowired
    PartyRepo partyRepo;
    @Autowired
    UserCredentialRepo userCredentialRepo;
    @Autowired
    PasswordEncoder passwordEncoder;

    public Party createVerifiedUser() {
//        return createUser("xyz@gmail.com", passwordEncoder.encode("Test1@@@"), true);
        return createUser("amnaaltaf242@gmail.com", passwordEncoder.encode("AmyMalik1@"), true);
    }
    public Party createUnVerifiedUser() {
        return createUser("xyz@gmail.com", passwordEncoder.encode("Test1@@@"), false);
    }

    public Party createUser(String email, String encodedPassword, Boolean accountVerify) {
        Party storeUser = new Party();
        storeUser.setFirstName("finest");
        storeUser.setLastName("resume");
        storeUser.setEmail(email);
        storeUser.setGender(Gender.Male);
        storeUser.setPhoneNumber("0578173969");
        storeUser.setAccountVerified(accountVerify);
        storeUser.setLocked(false);
        storeUser = partyRepo.save(storeUser);

        UserCredential userCredential = new UserCredential();
        userCredential.setPartyId(storeUser.getId());
        userCredential.setPassword(encodedPassword);
        userCredentialRepo.save(userCredential);

        return storeUser;
    }

}
