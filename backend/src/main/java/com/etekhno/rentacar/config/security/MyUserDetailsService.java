package com.etekhno.rentacar.config.security;

import com.etekhno.rentacar.common.exceptions.AuthenticationException;
import com.etekhno.rentacar.common.exceptions.UserAccountException;
import com.etekhno.rentacar.common.utils.DateHelper;
import com.etekhno.rentacar.config.ConfigProperties;
import com.etekhno.rentacar.datamodel.Party;
import com.etekhno.rentacar.datamodel.UserCredential;
import com.etekhno.rentacar.datamodel.repo.PartyRepo;
import com.etekhno.rentacar.datamodel.repo.UserCredentialRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Component;

import java.time.Duration;
import java.util.ArrayList;
import java.util.Date;
import java.util.Objects;
import java.util.Optional;

@Component
public class MyUserDetailsService implements UserDetailsService {
    @Autowired
    ConfigProperties configProperties;

    @Autowired
    PartyRepo partyRepo;
    @Autowired
    UserCredentialRepo userCredentialRepo;

    @Override
    public MyUserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        Optional<Party> findUser = partyRepo.findByEmailOrCnic(email, email);
        if(findUser.isEmpty())
            throw new UserAccountException(null, UserAccountException.Error.UserNotFoundError, " Not Found " + email);

        Party user = findUser.get();

        UserCredential userCredential = userCredentialRepo.findById(user.getId())
                .orElseThrow(()-> new UserAccountException(null, UserAccountException.Error.UserNotFoundError, "User is not properly registered."));
        if(Objects.equals(user.getLocked(), true) && Objects.nonNull(user.getLockedTime())) {
            Date unlockedTime  = DateHelper.addHoursInDate(user.getLockedTime(), configProperties.getBlockDurationHours());
            if (DateHelper.getCurrentDate().after(unlockedTime )) {
                userCredentialRepo.resetAttemptForUser(email);
                user.setLocked(false);
                userCredential.setLoginAttempt(0);
            } else {
                Long remainingTime = unlockedTime .getTime() -  DateHelper.getCurrentDate().getTime() ;
                Duration duration = Duration.ofMillis(remainingTime);
                long hoursDuration = duration.toHours();
                long minutesDuration = duration.toMinutesPart();

                String hours = hoursDuration == 0 ? "" : hoursDuration == 1 ? "1 hour" : hoursDuration + " hours";
                String minutes = minutesDuration == 0 ? "" : minutesDuration == 1 ? "1 minute" : minutesDuration + " minutes";
                String timePart = (hours.isEmpty() || minutes.isEmpty()) ? String.format("%s%s" ,hours, minutes) : String.format("%s and %s.", hours,  minutes);

                String message = String.format("Your account has been temporarily locked. Please try again after approximately %s.", timePart);

                if(hours.isEmpty() && minutes.isEmpty())
                    message = "You are in unlocking process. Please try again after few seconds.";

                throw new AuthenticationException(null, AuthenticationException.Error.UserAccountLockedError, message);
            }
        }

        return new MyUserDetails(user.getId(), userCredential.getLoginAttempt(), user.getEmail(), userCredential.getPassword(), true,true,true, !user.getLocked(), new ArrayList<>());
    }
}
